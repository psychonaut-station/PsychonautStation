import { strict as assert } from 'node:assert';
import { createComment } from './comment.js';

<<<<<<< HEAD
const baseRounds = [
  {
    round_id: 1,
    datetime: "2020-01-01 00:00:00",
  },
];
=======
const baseServers = {
  bagil: [
    {
      round_id: 1,
      datetime: '2020-01-01 00:00:00',
      server: 'bagil',
      url: 'https://tgstation13.org/round/1',
    },
  ],
};
>>>>>>> d9e687b5d3521b675bf81e714292794d25e5270c

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
<<<<<<< HEAD
    [
      {
        round_id: 2,
        datetime: "2020-01-01 01:00:00",
      },
    ],
    baseComment
=======
    {
      bagil: [
        {
          round_id: 2,
          datetime: '2020-01-01 01:00:00',
          server: 'bagil',
          url: 'https://tgstation13.org/round/2',
        },
      ],
    },
    baseComment,
>>>>>>> d9e687b5d3521b675bf81e714292794d25e5270c
  ),
  `<!-- test_merge_bot: 1, 2 -->
This pull request was test merged in 2 round(s).
<details><summary>Round list</summary>


- 2 @ 2020-01-01 01:00:00
- 1 @ 2020-01-01 00:00:00

</details>
`
);
