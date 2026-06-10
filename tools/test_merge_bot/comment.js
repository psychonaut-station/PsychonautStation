const FIND_EXISTING_ENTRIES = /\n\n\n((?:- .+\n)*)/g;
const ENTRY_PATTERN = /- (?<round_id>[0-9]+) @ (?<datetime>.+?)$/;

export const createComment = (rounds, existingComment) => {
  if (existingComment) {
<<<<<<< HEAD
    for (const [, entries] of existingComment.matchAll(FIND_EXISTING_ENTRIES)) {
      for (const line of entries.split("\n")) {
=======
    for (const [, serverName, entries] of existingComment.matchAll(
      FIND_EXISTING_ENTRIES,
    )) {
      let server = servers[serverName];
      if (!server) {
        server = [];
        servers[serverName] = server;
      }

      for (const line of entries.split('\n')) {
>>>>>>> 408ded23854c4b0cbeb62d199e92e66ff52f2337
        const match = line.match(ENTRY_PATTERN);
        if (!match) {
          continue;
        }

        const { round_id: roundIdString, datetime } = match.groups;
        const round_id = parseInt(roundIdString, 10);

        if (rounds.find((round) => round.round_id === round_id)) {
          continue;
        }

        rounds.push({
          round_id,
          datetime,
        });
      }
    }
  }

  const roundIds = rounds
    .map(({ round_id }) => round_id)
    .sort()
    .join(', ');

  const newHeader = `<!-- test_merge_bot: ${roundIds} -->`;

  if (existingComment?.startsWith(newHeader)) {
    return null;
  }

<<<<<<< HEAD
  let totalRounds = rounds.length;
  let listOfRounds = "";
=======
  let totalRounds = 0;
  let listOfRounds = '';
>>>>>>> 408ded23854c4b0cbeb62d199e92e66ff52f2337

  for (const { datetime, round_id } of rounds.sort(
    (a, b) => b.round_id - a.round_id
  )) {
<<<<<<< HEAD
    listOfRounds += `${"\n"}- ${round_id} @ ${datetime}`;
=======
    totalRounds += rounds.length;

    listOfRounds += `${'\n'}### ${server}`;

    for (const { datetime, round_id, url } of rounds.sort(
      (a, b) => b.round_id - a.round_id,
    )) {
      listOfRounds += `${'\n'}- [${round_id} @ ${datetime}](${url})`;
    }

    listOfRounds += '\n';
>>>>>>> 408ded23854c4b0cbeb62d199e92e66ff52f2337
  }

  listOfRounds += "\n";

  return (
    newHeader +
    `\nThis pull request was test merged in ${totalRounds} round(s).` +
    '\n' +
    '<details><summary>Round list</summary>\n\n' +
    listOfRounds +
    '\n</details>\n'
  );
};
