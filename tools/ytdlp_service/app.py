import argparse
import json
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any
from urllib.parse import parse_qs, urlparse

from yt_dlp import YoutubeDL


YTDLP_FORMAT = 'bestaudio[ext=mp3]/best[ext=mp4][height <= 360]/bestaudio[ext=m4a]/bestaudio[ext=aac]'


def _response(handler: BaseHTTPRequestHandler, status_code: int, payload: dict[str, Any]|str) -> None:
	body = (payload if isinstance(payload, str) else json.dumps(payload, ensure_ascii=True)).encode("utf-8")
	handler.send_response(status_code)
	handler.send_header("Content-Type", "application/json; charset=utf-8")
	handler.send_header("Content-Length", str(len(body)))
	handler.end_headers()
	handler.wfile.write(body)


def _resolve_track(url: str, timeout_seconds: int) -> tuple[int, str]:
	parsed_url = urlparse(url)
	if parsed_url.scheme not in {"http", "https"} or not parsed_url.netloc:
		return 400, json.dumps({"error": "invalid_url", "detail": "URL must use HTTP or HTTPS."})

	try:
		ytdlp_params: Any = {
			"format": YTDLP_FORMAT,
			"ignoreconfig": True,
			"geo_bypass": True,
			"noplaylist": True,
			"quiet": True,
			"no_warnings": True,
			"socket_timeout": timeout_seconds,
		}
		with YoutubeDL(ytdlp_params) as ytdlp:
			raw_track_data: Any = ytdlp.extract_info(url, download=False)
	except Exception as exc:
		return 502, json.dumps({
			"error": "yt_dlp_failed",
			"detail": str(exc),
		})

	if raw_track_data is None:
		return 502, json.dumps({"error": "yt_dlp_failed", "detail": "yt-dlp returned an unexpected payload."})

	track_data: dict[str, Any] = raw_track_data
	return 200, json.dumps(track_data, ensure_ascii=True)


class YtDlpHandler(BaseHTTPRequestHandler):
	server_version = "yt-dlp-wrapper/1.0"

	def log_message(self, format: str, *args: object) -> None:
		return

	def do_GET(self) -> None:
		request_path = self.path.split("?", 1)[0].rstrip("/")

		if request_path == "/health":
			_response(self, 200, {"ok": True})
			return

		if request_path not in {"", "/resolve"}:
			_response(self, 404, {"error": "not_found"})
			return

		query = parse_qs(self.path.split("?", 1)[1] if "?" in self.path else "")
		url = query.get("url", [""])[0].strip()
		if not url:
			_response(self, 400, {"error": "missing_url", "detail": "Query string must include a non-empty url parameter."})
			return

		try:
			status_code, body = _resolve_track(url, int(os.environ.get("YTDLP_TIMEOUT", "120")))
		except Exception as exc:
			_response(self, 500, {"error": "internal_error", "detail": str(exc)})
			return

		_response(self, status_code, body)


def main() -> None:
	parser = argparse.ArgumentParser(description="Resolve media metadata through yt-dlp over HTTP.")
	parser.add_argument("--host", default=os.environ.get("YTDLP_BIND", "0.0.0.0"))
	parser.add_argument("--port", type=int, default=int(os.environ.get("YTDLP_PORT", "8080")))
	args = parser.parse_args()

	server = ThreadingHTTPServer((args.host, args.port), YtDlpHandler)
	print(f"yt-dlp wrapper listening on {args.host}:{args.port}", flush=True)
	server.serve_forever()


if __name__ == "__main__":
	main()
