import { strict as assert } from "assert";
import { createComment } from "./comment.js";

<<<<<<< HEAD
const baseRounds = [
	{
		round_id: 1,
		datetime: "2020-01-01 00:00:00",
	},
];

const baseComment = createComment(
	baseRounds,
=======
const baseServers = {
  bagil: [
    {
      round_id: 1,
      datetime: "2020-01-01 00:00:00",
      server: "bagil",
      url: "https://tgstation13.org/round/1",
    },
  ],
};

const baseComment = createComment(
  baseServers,
>>>>>>> 9db2f6916be5791a84b369eb07bcff178c547e61

  null,
);

assert.equal(
  baseComment,
  `<!-- test_merge_bot: 1 -->
This pull request was test merged in 1 round(s).
<details><summary>Round list</summary>


- 1 @ 2020-01-01 00:00:00

</details>
`,
);

assert.equal(createComment(baseRounds, baseComment), null);

assert.equal(
<<<<<<< HEAD
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
=======
  createComment(
    {
      bagil: [
        {
          round_id: 2,
          datetime: "2020-01-01 01:00:00",
          server: "bagil",
          url: "https://tgstation13.org/round/2",
        },
      ],
    },
    baseComment,
  ),
  `<!-- test_merge_bot: 1, 2 -->
>>>>>>> 9db2f6916be5791a84b369eb07bcff178c547e61
This pull request was test merged in 2 round(s).
<details><summary>Round list</summary>


- 2 @ 2020-01-01 01:00:00
- 1 @ 2020-01-01 00:00:00

</details>
`,
);
