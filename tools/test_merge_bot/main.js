import fetch from "node-fetch";
import { createComment } from "./comment.js";

const TEST_MERGE_COMMENT_HEADER = "<!-- test_merge_bot:";

const { GET_TEST_MERGES_URL } = process.env;

if (!GET_TEST_MERGES_URL) {
  console.error("GET_TEST_MERGES_URL was not set.");
  process.exit(1);
}

export async function processTestMerges({ github, context }) {
  const rounds = await fetch(GET_TEST_MERGES_URL)
    .then(async (response) => {
      if (response.status !== 200) {
        return Promise.reject(
          `Failed to fetch test merges: ${
            response.status
          } ${await response.text()}`,
        );
      }

      return response;
    })
    .then((response) => response.json())
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });

  // PSYCHONAUT EDIT ADDITION BEGIN - Original:
  /*
  // PR # -> server name -> test merge struct
  const testMergesPerPr = {};

  for (const round of rounds) {
    const { server, test_merges } = round;

    for (const testMerge of test_merges) {
      if (!testMergesPerPr[testMerge]) {
        testMergesPerPr[testMerge] = {};
      }

      if (!testMergesPerPr[testMerge][server]) {
        testMergesPerPr[testMerge][server] = [];
      }

      testMergesPerPr[testMerge][server].push(round);
    }
  }
  */
  // PR # -> test merge struct
  const testMergesPerPr = {};

  for (const round of rounds) {
    const { test_merges } = round;

    for (const testMerge of test_merges) {
      if (!testMergesPerPr[testMerge]) {
        testMergesPerPr[testMerge] = [];
      }

      testMergesPerPr[testMerge].push(round);
    }
  }
  // PSYCHONAUT EDIT ADDITION END

  // PSYCHONAUT EDIT ADDITION BEGIN - Original:
  // for (const [prNumber, servers] of Object.entries(testMergesPerPr)) {
  for (const [prNumber, rounds] of Object.entries(testMergesPerPr)) {
  // PSYCHONAUT EDIT ADDITION END
    const comments = await github.graphql(
      `
		query($owner:String!, $repo:String!, $prNumber:Int!) {
			repository(owner: $owner, name: $repo) {
				pullRequest(number: $prNumber) {
					comments(last: 100) {
						nodes {
							body
							databaseId
							author {
								login
							}
						}
					}
				}
			}
		}`,
      {
        owner: context.repo.owner,
        repo: context.repo.repo,
        prNumber: parseInt(prNumber, 10),
      },
    );

    const existingComment = comments.repository.pullRequest.comments.nodes.find(
      (comment) =>
        comment.author?.login === "github-actions" &&
        comment.body.startsWith(TEST_MERGE_COMMENT_HEADER),
    );
    // PSYCHONAUT EDIT ADDITION BEGIN - Original:
    // const newBody = createComment(servers, existingComment?.body);
    const newBody = createComment(rounds, existingComment?.body);
    // PSYCHONAUT EDIT ADDITION END

    if (!newBody) {
      console.log(`No changes for PR #${prNumber}`);
      continue;
    }

    if (existingComment === undefined) {
      try {
        await github.rest.issues.createComment({
          owner: context.repo.owner,
          repo: context.repo.repo,
          issue_number: prNumber,
          body: newBody,
        });
      } catch (error) {
        if (error.status) {
          console.error(`Failed to create comment for #{prNumber}`);
          console.error(error);
          continue;
        } else {
          throw error;
        }
      }
    } else {
      try {
        await github.rest.issues.updateComment({
          owner: context.repo.owner,
          repo: context.repo.repo,
          comment_id: existingComment.databaseId,
          body: newBody,
        });
      } catch (error) {
        if (error.status) {
          console.error(`Failed to update comment for #{prNumber}`);
          console.error(error);
          continue;
        } else {
          throw error;
        }
      }
    }
  }
}
