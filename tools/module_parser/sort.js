import path from "node:path";
import fs from 'node:fs';
import Bun from 'bun';

await main();

async function main() {
  if (Bun.argv.length < 3) return console.error("No arguments");

  const filePath = Bun.argv[2];

  console.log("File:", filePath);

  const file = Bun.file(filePath);

  if (!(await file.exists())) return console.error("File doesnt exist");

  const data = await file.text();
  const lines = data.split(/\r?\n/);
  lines.push("### temporary");

  const all_titles = [];
  let current_title = null;

  for (const line of lines) {
    const trimmed = line.trim();

    if (trimmed.startsWith("##") && trimmed !== "##") {
      if (current_title != null) {
        current_title["lines"] = sortItems(current_title["lines"]);
        all_titles.push(current_title);
      }
      current_title = {
        heading_marker: null,
        title: null,
        lines: [],
      };
      const the_title = trimmed.replace("#", "").replace("#", "").replace("#", "").trim();
      current_title["title"] = the_title;
      current_title["heading_marker"] = trimmed.replace(the_title, "").trim();
      continue;
    } else if (trimmed !== "") {
      current_title["lines"].push(line);
    }
  }

  const file_lines = [];
  all_titles.forEach((title) => {
    file_lines.push(`${title["heading_marker"]} ${title["title"]}`);
    file_lines.push("");
    title["lines"].forEach((line) => {
      file_lines.push(line);
    });
    file_lines.push("");
  });

  const file_text = file_lines.join("\n");
  await Bun.write(filePath, file_text);
  console.log("Done");
}

function sortItems(lines) {
  const nonDashLines = [];
  const dashItems = [];

  lines.forEach((line) => {
    if (line.startsWith("- ")) {
      const specialCases = /^- (N\/A)$/i;
      if (specialCases.test(line)) {
        dashItems.push(line);
        return;
      }

      const match = line.match(/- `([^`]+)`(:.*)?/);

      if (match) {
        let valuePart = match[2] || "";
        if (valuePart === ":") valuePart = "";
        const fixedLine = `- \`${match[1].trim()}\`${valuePart}`;
        dashItems.push(fixedLine);
      } else {
        const wordMatch = line.match(/- ?`?(\w+)`?/);
        if (wordMatch) {
          const fixedLine = `- \`${wordMatch[1]}\``;
          dashItems.push(fixedLine);
        } else {
          nonDashLines.push(line);
        }
      }
    } else {
      nonDashLines.push(line);
    }
  });

  const sortedDashItems = dashItems.sort();

  return [...nonDashLines, ...sortedDashItems];
}
