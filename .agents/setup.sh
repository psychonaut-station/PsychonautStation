#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# shellcheck source=dependencies.sh
source dependencies.sh

# Ensure non-interactive shells sourcing ~/.bashrc execute our PATH/LD_LIBRARY_PATH exports.
sed -i '/case \$- in/,/esac/d' "$HOME/.bashrc" 2>/dev/null || true

append_bashrc() {
	local line="$1"
	touch "$HOME/.bashrc"
	grep -qxF "$line" "$HOME/.bashrc" || echo "$line" >> "$HOME/.bashrc"
}

# 1. System 32-bit runtime libraries needed by BYOND, rust_g, and dreamluau.
APT_PKGS=()
for pkg in libc6-i386 lib32stdc++6 lib32z1; do
	if ! dpkg -s "$pkg" >/dev/null 2>&1; then
		APT_PKGS+=("$pkg")
	fi
done

if [ ! -f "$HOME/BYOND/byond/bin/libcurl.so.4" ] && ! dpkg -s gcc-multilib >/dev/null 2>&1; then
	APT_PKGS+=(gcc-multilib)
fi

if [ "${#APT_PKGS[@]}" -gt 0 ]; then
	sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${APT_PKGS[@]}"
fi

# 2. Bun (exact version from dependencies.sh).
if ! [ -x "$HOME/.bun/bin/bun" ] || [ "$("$HOME/.bun/bin/bun" --version)" != "$BUN_VERSION" ]; then
	BUN_INSTALL="$HOME/.bun" curl -fsSL https://bun.sh/install | BUN_INSTALL="$HOME/.bun" bash -s "bun-v${BUN_VERSION}"
fi
append_bashrc 'export BUN_INSTALL="$HOME/.bun"'
append_bashrc 'export PATH="$HOME/.bun/bin:$PATH"'
export BUN_INSTALL="$HOME/.bun"
export PATH="$HOME/.bun/bin:$PATH"

# 3. BYOND (DreamMaker & DreamDaemon) + 32-bit libcurl.so.4.
bash tools/ci/install_byond.sh

if [ ! -f "$HOME/BYOND/byond/bin/libcurl.so.4" ]; then
	if ! dpkg -s gcc-multilib >/dev/null 2>&1; then
		sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
		sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gcc-multilib
	fi
	CURL_TMP="$(mktemp -d)"
	(
		trap 'rm -rf "$CURL_TMP"' EXIT
		curl -fsSL "https://github.com/curl/curl/releases/download/curl-8_11_1/curl-8.11.1.tar.gz" -o "$CURL_TMP/curl.tar.gz"
		tar -xzf "$CURL_TMP/curl.tar.gz" -C "$CURL_TMP"
		cd "$CURL_TMP/curl-8.11.1"
		CFLAGS="-m32 -O2" LDFLAGS="-m32" ./configure \
			--host=i686-pc-linux-gnu \
			--without-ssl --without-libpsl --without-zstd --without-brotli --without-nghttp2 --without-libidn2 --without-zlib \
			--disable-ftp --disable-ldap --disable-ldaps --disable-rtsp --disable-dict --disable-telnet \
			--disable-tftp --disable-pop3 --disable-imap --disable-smb --disable-smtp --disable-gopher \
			--disable-mqtt --disable-manual --disable-docs --disable-static --disable-libcurl-option
		make -j"$(nproc)" -C lib
		cp -L lib/.libs/libcurl.so.4 "$HOME/BYOND/byond/bin/libcurl.so.4"
	)
fi

# 4. Native SS13 shared libraries (rust_g and dreamluau).
mkdir -p "$HOME/.byond/bin"
if [ ! -f "$HOME/.byond/bin/librust_g.so" ] || ! grep -Fxq "$RUST_G_VERSION" "$HOME/.byond/bin/.rust_g.version" 2>/dev/null; then
	bash tools/ci/install_rust_g.sh
	echo "$RUST_G_VERSION" > "$HOME/.byond/bin/.rust_g.version"
fi

if [ ! -f "$HOME/.byond/bin/libdreamluau.so" ] || ! grep -Fxq "$DREAMLUAU_VERSION" "$HOME/.byond/bin/.dreamluau.version" 2>/dev/null; then
	bash tools/ci/install_dreamluau.sh
	echo "$DREAMLUAU_VERSION" > "$HOME/.byond/bin/.dreamluau.version"
fi

# 5. SpacemanDMM dreamchecker.
if [ -L "$HOME/dreamchecker" ] && ! grep -Fxq "$SPACEMAN_DMM_VERSION" "$HOME/SpacemanDMM/dreamchecker.version" 2>/dev/null; then
	rm -f "$HOME/dreamchecker"
fi
bash tools/ci/install_spaceman_dmm.sh dreamchecker

# 6. OpenDream DMCompiler.
if [ ! -x "$HOME/OpenDream/DMCompiler_linux-x64/DMCompiler" ]; then
	mkdir -p "$HOME/OpenDream"
	OD_TMP="$(mktemp -d)"
	(
		trap 'rm -rf "$OD_TMP"' EXIT
		curl -fsSL "https://github.com/OpenDreamProject/OpenDream/releases/download/latest/DMCompiler_linux-x64.tar.gz" -o "$OD_TMP/dmcompiler.tar.gz"
		tar -xzf "$OD_TMP/dmcompiler.tar.gz" -C "$HOME/OpenDream"
	)
fi

# Persist BYOND, SpacemanDMM, and OpenDream paths.
append_bashrc 'export BYOND_SYSTEM="$HOME/BYOND/byond"'
append_bashrc 'export PATH="$HOME/BYOND/byond/bin:$HOME/SpacemanDMM:$HOME/OpenDream/DMCompiler_linux-x64:$PATH"'
append_bashrc 'export LD_LIBRARY_PATH="$HOME/BYOND/byond/bin${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"'
export BYOND_SYSTEM="$HOME/BYOND/byond"
export PATH="$HOME/BYOND/byond/bin:$HOME/SpacemanDMM:$HOME/OpenDream/DMCompiler_linux-x64:$PATH"
export LD_LIBRARY_PATH="$HOME/BYOND/byond/bin${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

# 7. Python tools virtualenv bootstrap.
tools/bootstrap/python -c ''

# 8. Icon cutter (hypnagogic).
tools/build/build.sh cutter

# 9. JavaScript / TGUI dependencies.
bun install --frozen-lockfile
(cd tgui && bun install --frozen-lockfile --ignore-scripts)
