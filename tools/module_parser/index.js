const fs = require('fs');
const path = require('path');

if(process.argv.slice(2).length !== 1) return console.error("No arguments")

const filePath = process.argv.slice(2)[0]
const formattedDate = `${Date.now()}-`;

console.log("File:", filePath);
(()=>{
  if(!fs.existsSync(filePath)) return console.error("File doesnt exist")

  const dir = path.dirname(filePath);
  const base = path.basename(filePath);
  const backupPath = path.join(dir, `${formattedDate}${base}.old`);

  fs.copyFileSync(filePath, backupPath);

  const data = fs.readFileSync(filePath, 'utf8');
  const lines = data.split(/\r?\n/);
  lines.push("### temporary")

  const all_titles = []
  let current_title = null
  for (const line of lines) {
      const trimmed = line.trim();

      if(trimmed.startsWith("##") && trimmed !== "##") {
          if(current_title != null) {
              current_title["lines"] = sortListItems(current_title["lines"])
              all_titles.push(current_title)
          }
          current_title = {
              heading_marker: null,
              title: null,
              lines: []
          };
          const the_title = trimmed.replace("#", "").replace("#", "").replace("#", "").trim()
          current_title["title"] = the_title
          current_title["heading_marker"] = trimmed.replace(the_title, "").trim()
          continue;
      } else if(trimmed !== '') {
          current_title["lines"].push(line)
      }
  }

  const file_lines = []
  all_titles.forEach((title) => {
    file_lines.push(`${title["heading_marker"]} ${title["title"]}`)
    file_lines.push('')
    title["lines"].forEach((line) => {
      file_lines.push(line)
    })
    file_lines.push('')
  })

  const file_text = file_lines.join("\n")
  fs.writeFileSync(filePath, file_text, "utf8");
  console.log("Done")
})()

function sortListItems(lines) {
  const nonDashLines = [];
  const dashItems = [];

  lines.forEach(line => {
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
