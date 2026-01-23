import path from "node:path";
import fs from 'node:fs';
import Bun, { Glob } from 'bun';

await main();

async function main() {
    if (Bun.argv.length < 3) return console.error("No arguments");

    const baslangic = performance.now();
    const readmeFilePath = Bun.argv[2];

    const readmeFile = Bun.file(readmeFilePath);

    if (!(await readmeFile.exists())) return console.error("File doesnt exist");

    const dir = path.dirname(readmeFilePath);
    const base = path.basename(readmeFilePath);
    const backupPath = path.join(dir, `${base}.old`);

    await Bun.write(backupPath, readmeFile);

    const file_data = await readmeFile.text();


    const newdata = await readAllFiles(file_data)
    var all_titles = await deleteOldLines(file_data)

    const title_module = all_titles[0];
    const title_desc = all_titles[1];
    const title_tg = all_titles[2];
    const title_modular = all_titles[3];
    const title_defnhelpers = all_titles[4];
    const title_notincludedmodular = all_titles[5];
    const title_credits = all_titles[6];

    Object.entries(newdata).forEach(([key, value]) => {
        const newvalue = value.map(item => `\`${item}\``).join(', ');
        if(key.startsWith("code/__HELPERS") || key.startsWith("code/__DEFINES")) {
            title_defnhelpers.lines.push(`- \`${key}\`: ${newvalue}`)
        } else {
            title_tg.lines.push(`- \`${key}\`: ${newvalue}`)
        }
    });
    title_defnhelpers.lines = title_defnhelpers.lines.filter(item => item !== "- N/A")

    var all_titles = [
        title_module,
        title_desc,
        title_tg,
        title_modular,
        title_defnhelpers,
        title_notincludedmodular,
        title_credits
    ]

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
    await Bun.write(readmeFilePath, file_text);
    const bitis = performance.now();
    const gecenSure = (bitis - baslangic) / 1000;
    console.log(gecenSure.toFixed(2) + 'sn')
}

async function deleteOldLines(data) {
  const lines = data.split(/\r?\n/);
  lines.push("### temporary");

  const all_titles = [];
  let current_title = null;

  for (const line of lines) {
    const trimmed = line.trim();

    if (trimmed.startsWith("##") && trimmed !== "##") {
        if (current_title != null) {
          const newlines = []
          current_title["lines"].forEach((line) => {
              if(!(line.match(/^-\s*`(.+?\.dm)`/) && !line.includes("code/__DEFINES/~psychonaut_defines") && !line.includes("code/__HELPERS/~psychonaut_helpers") && !line.includes("modular_psychonaut/"))) newlines.push(line)
          });
          current_title["lines"] = newlines.length > 0 ? newlines : ['- N/A']

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
  return all_titles
}

async function readAllFiles(data) {
    const idMatch = data.match(/MODULE ID:\s*(.+)/);
    const foundModuleID = idMatch ? idMatch[1].trim().replace(/[.*+?^${}()|[\]\\]/g, '\\$&') : null;

    if (!foundModuleID) return console.error("MODULE ID not found");

    const targetFolders = [
        path.resolve(import.meta.dir, "../../code"),
        path.resolve(import.meta.dir, "../../interface"),
    ];

    const glob = new Glob("**/*.dm");

    const dosyaRaporu = {};

    let a = 0;
    let b = 0;
    for (const folder of targetFolders) {
        const folderName = path.basename(folder);
        for await (const file of glob.scan(folder)) {
            const readedFile = Bun.file(folder + '/' + file);
            const data = await readedFile.text();
            const lines = data.split(/\r?\n/);

            a += 1;

            const thisFileFound = new Set();

            // Dosya genelinde takibimiz
            let lastContext = "GLOBAL";
            let contextType = "DATUM";

            // Blok içi takiplerimiz
            let insideBlock = false;

            let blockBeginContext = "";
            let insideBlockContext = "";
            let insideBlockType = "";

            let insideBlockFound = new Set();

            let multiLineCommentMode = false;

            for (let i = 0; i < lines.length; i++) {
                const line = lines[i];
                let trimLine = line.trim();

                if (!trimLine) continue;

                if (trimLine.startsWith("///")) continue;

                // --- YORUM TEMİZLEME ---
                let analyzableCode = trimLine;

                if (multiLineCommentMode) {
                    if (analyzableCode.includes("*/")) {
                        analyzableCode = analyzableCode.split("*/")[1] || "";
                        multiLineCommentMode = false;
                    } else {
                        analyzableCode = "";
                    }
                }

                if (!multiLineCommentMode) {
                    analyzableCode = analyzableCode.split("//")[0];
                    analyzableCode = analyzableCode.replace(/\/\*.*?\*\//g, "");
                    if (analyzableCode.includes("/*")) {
                        analyzableCode = analyzableCode.split("/*")[0];
                        multiLineCommentMode = true;
                    }
                }

                analyzableCode = analyzableCode.trim();

                // --- DOSYA GENELİ CONTEXT GÜNCELLEME ---
                if (analyzableCode.startsWith("/") && !analyzableCode.startsWith("/var")) {
                    if (analyzableCode.endsWith(")")) {
                        let rawPath = analyzableCode.split("{")[0].trim();
                        lastContext = formatProcPath(rawPath);
                        contextType = "PROC";
                    } else {
                        if (!analyzableCode.includes("=")) {
                             let rawContext = analyzableCode.split("{")[0].trim();
                             lastContext = rawContext;
                             contextType = "DATUM";
                        }
                    }
                }

                // --- BLOCK BEGIN ---
                if ((line.includes("BEGIN") || line.includes("START")) && line.includes(foundModuleID)) {
                    if(insideBlock) {
                        console.error(`${foundModuleID} block is already open. Skipping ${i} in ${'code\\' + file}`)
                    }
                    insideBlock = true;
                    blockBeginContext = lastContext;
                    insideBlockContext = lastContext;
                    insideBlockType = contextType;
                    insideBlockFound = new Set();
                    b += 1;
                    continue;
                }

                // --- BLOCK END ---
                if ((line.includes("END") || line.includes("STOP")) && line.includes(foundModuleID)) {
                    insideBlock = false;
                    b += 1;

                    if (insideBlockFound.size > 0) {
                        insideBlockFound.forEach(item => thisFileFound.add(item));
                    } else {
                        thisFileFound.add(blockBeginContext);
                    }
                    continue;
                }

                if (insideBlock) {
                    let ghostCode = trimLine;
                    ghostCode = ghostCode.replace(/\/\//g, "").replace(/\/\*/g, "").replace(/\*\//g, "").trim();

                    if (!ghostCode) continue;

                    // 1. Define
                    if (ghostCode.startsWith("#define")) {
                        insideBlockFound.add(extractDefineName(ghostCode));
                    }
                    // 2. Variable (var/x)
                    else if (ghostCode.startsWith("var/") || ghostCode.startsWith("/var")) {
                         const varName = extractVarName(ghostCode);

                         if (ghostCode.startsWith("/")) {
                            let fullPathVar = ghostCode.split("=")[0].trim();
                            insideBlockFound.add(fullPathVar);
                         }
                         else if (insideBlockType === "DATUM") {
                            insideBlockFound.add(`${insideBlockContext}/var/${varName}`);
                         }
                    }
                    // 3. GLOBAL
                    else if (ghostCode.startsWith("GLOBAL")) {
                        let globContent = ghostCode.split("(")[1];
                        if (globContent) {
                            let globName = globContent.split(/[,\)]/)[0].trim();
                            insideBlockFound.add(`GLOB.${globName}`);
                        }
                    }
                    // 4. Path (/datum/...) & Context Switch
                    else if (ghostCode.startsWith("/") && !ghostCode.startsWith("/var")) {
                         if (!ghostCode.includes("=")) {
                            let potentialPath = ghostCode.split("{")[0].trim();
                            let formattedPath = potentialPath;

                            if (potentialPath.endsWith(")")) {
                                formattedPath = formatProcPath(potentialPath);
                                insideBlockType = "PROC";
                            } else {
                                insideBlockType = "DATUM";
                            }

                            insideBlockFound.add(formattedPath);
                            insideBlockContext = formattedPath;
                         }
                    }
                    // 5. Override (name = "X")
                    else if (insideBlockType === "DATUM" && /^[a-zA-Z0-9_]+\s*=/.test(ghostCode)) {
                        let varName = ghostCode.split("=")[0].trim();
                        insideBlockFound.add(`${insideBlockContext}/var/${varName}`);
                    }

                    continue;
                }

                if (line.includes(foundModuleID) && line.includes("//")) {
                    const parts = line.split("//");
                    const commentPart = parts[parts.length - 1];
                    let codePart = parts.slice(0, -1).join("//").trim();

                    const isCodeCommentedOut = (codePart.length > 0 && analyzableCode.length === 0);

                    if (commentPart.includes(foundModuleID)) {

                        if (!codePart || isCodeCommentedOut) {
                            if (commentPart.includes("START") || commentPart.includes("BEGIN") || commentPart.includes("END") || commentPart.includes("STOP")) {
                                thisFileFound.add(lastContext);
                                b += 1;
                            }
                        }
                        else if (codePart.startsWith("#define")) {
                            const defineName = extractDefineName(codePart);
                            thisFileFound.add(`${defineName}`);
                            b += 1;
                        }
                        else if (codePart.startsWith("GLOBAL")) {
                            let globContent = codePart.split("(")[1];
                            if (globContent) {
                                let globName = globContent.split(/[,\)]/)[0].trim();
                                thisFileFound.add(`GLOB.${globName}`);
                                b += 1;
                            }
                        }
                        else if (codePart.startsWith("/") && codePart.endsWith(")")) {
                            thisFileFound.add(formatProcPath(codePart));
                            b += 1;
                        }
                        else if (codePart.startsWith("var/") || codePart.startsWith("/var")) {
                            if (contextType === "DATUM") {
                               const varName = extractVarName(codePart);
                               thisFileFound.add(`${lastContext}/var/${varName}`);
                            } else {
                               thisFileFound.add(lastContext);
                            }
                            b += 1;
                        }
                        else {
                            if (contextType === "DATUM" && /^[a-zA-Z0-9_]+\s*=/.test(codePart)) {
                                let varName = codePart.split("=")[0].trim();
                                thisFileFound.add(`${lastContext}/var/${varName}`);
                            } else {
                                thisFileFound.add(lastContext);
                            }
                            b += 1;
                        }
                    }
                }
            }

            if (thisFileFound.size > 0) {
                const finalBulgular = new Set();
                for (const item of thisFileFound) {
                    if (item.includes("/var/")) {
                        const parentPath = item.split("/var/")[0];
                        if (thisFileFound.has(parentPath)) {
                            continue;
                        }
                    }
                    finalBulgular.add(item);
                }
                const fullPath = (folderName + '/' + file).replace(/\\/g, '/');
                dosyaRaporu[fullPath] = Array.from(finalBulgular);
            }
        }
    }

    return dosyaRaporu
}

function extractVarName(codePart) {
    let clean = codePart.trim();
    clean = clean.replace(/^\/?var\/?/, "");
    clean = clean.split("=")[0].trim();
    clean = clean.split("(")[0].trim();
    const parts = clean.split("/");
    return parts[parts.length - 1];
}

function extractDefineName(codePart) {
    let clean = codePart.trim().replace(/^#define\s+/, "");
    let firstPart = clean.split(/[\s\t]+/)[0];
    return firstPart.split("(")[0].trim();
}

function formatProcPath(path) {
    let noArgs = path.split("(")[0].trim();
    if (noArgs.startsWith("/proc/")) {
        return noArgs + "()";
    }
    if (noArgs.startsWith("/verb/")) {
        return noArgs + "()";
    }
    return noArgs.replace("/proc/", "/").replace("/verb/", "/") + "()";
}
