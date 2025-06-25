import { strict as assert } from "assert";
import { createComment } from "./comment.js";

const baseRounds = [
  {
    round_id: 1,
    datetime: "2020-01-01 00:00:00",
  },
];

const baseComment = createComment(baseRounds, null);

assert.equal(
  baseComment,
  `<!-- test_merge_bot: 1 -->
This pull request was test merged in 1 round(s).
<details><summary>Round list</summary>


- 1 @ 2020-01-01 00:00:00

</details>
`
);

assert.equal(createComment(baseRounds, baseComment), null);

assert.equal(
  createComment(
    [
      {
        round_id: 2,
        datetime: "2020-01-01 01:00:00",
      },
    ],
    baseComment
  ),
  `<!-- test_merge_bot: 1, 2 -->
This pull request was test merged in 2 round(s).
<details><summary>Round list</summary>


- 2 @ 2020-01-01 01:00:00
- 1 @ 2020-01-01 00:00:00

</details>
`
);
