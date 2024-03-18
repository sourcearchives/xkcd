<div align="center">

If you like formal logic, graph theory, sappy romance, bitter sarcasm, puns, or landscape art, check out my webcomic, <a href="https://www.xkcd.com/">xkcd</a>).

[![](../../xkcd/comics/0001-0099/0082/1x.jpg)](https://www.xkcd.com/)

## Solution to the [Blue Eyes](https://www.xkcd.com/blue_eyes.html) puzzle

</div>

The answer is that on the 100th day, all 100 blue-eyed people will leave. It's pretty convoluted logic and it took me a while to believe the solution, but here's a rough guide to how to get there.  Note -- while the text of the puzzle is very carefully worded to be as clear and unambiguous as possible (thanks to countless discussions with confused readers), this solution is pretty thrown-together. It's correct, but the explanation/wording might not be the best. If you're really confused by something, let me know.

If you consider the case of just one blue-eyed person on the island, you can show that he obviously leaves the first night, because he knows he's the only one the Guru could be talking about. He looks around and sees no one else, and knows he should leave. So: <b>[THEOREM 1]</b> If there is one blue-eyed person, he leaves the first night.

If there are two blue-eyed people, they will each look at the other. They will each realize that "<b>if</b> I don't have blue eyes <b>[HYPOTHESIS 1]</b>, <b>then</b> that guy is the only blue-eyed person. And <b>if</b> he's the only person, by <b>THEOREM 1</b> he will leave tonight." They each wait and see, and when neither of them leave the first night, each realizes "My <b>HYPOTHESIS 1</b> was incorrect. I must have blue eyes." And each leaves the second night.

So: <b>[THEOREM 2]</b>: If there are two blue-eyed people on the island, they will each leave the 2nd night.

If there are three blue-eyed people, each one will look at the other two and go through a process similar to the one above. Each considers the two possibilities -- "I have blue eyes" or "I don't have blue eyes." He will know that if he doesn't have blue eyes, there are only two blue-eyed people on the island -- the two he sees. So he can wait two nights, and if no one leaves, he knows he must have blue eyes -- <b>THEOREM 2</b> says that if he didn't, the other guys would have left. When he sees that they didn't, he knows his eyes are blue. All three of them are doing this same process, so they all figure it out on day 3 and leave.

This induction can continue all the way up to <b>THEOREM 99</b>, which each person on the island in the problem will of course know immediately. Then they'll each wait 99 days, see that the rest of the group hasn't gone anywhere, and on the 100th night, they all leave.

Before you email me to argue or question: This solution is correct. My explanation may not be the clearest, and it's very difficult to wrap your head around (at least, it was for me), but the facts of it are accurate. I've talked the problem over with many logic/math professors, worked through it with students, and analyzed from a number of different angles. The answer is correct and proven, even if my explanations aren't as clear as they could be.

User lolbifrons on reddit posted <a href="https://www.reddit.com/r/AskReddit/comments/khhpl/reddit_what_is_your_favorite_riddle/c2kdlr6">an inductive proof</a>.

If you're satisfied with this answer, here are a couple questions that may force you to further explore the structure of the puzzle:

  1. What is the quantified piece of information that the Guru provides that each person did not already have?
  2. Each person knows, from the beginning, that there are no less than 99 blue-eyed people on the island. How, then, is considering the 1 and 2-person cases relevant, if they can all rule them out immediately as possibilities?
  3. Why do they have to wait 99 nights if, on the first 98 or so of these nights, they're simply verifying something that they already know?

These are just to give you something to think about if you enjoyed the main solution. They have answers, but please don't email me asking for them. They're meant to prompt thought on the solution, and each can be answered by considering the solution from the right angle, in the right terms. There's a different way to think of the solution involving hypotheticals inside hypotheticals, and it is much more concrete, if a little harder to discuss. But in it lies the key to answering the four questions above.

<div align="center">

[![](../../xkcd/comics/0001-0099/0037/1x.jpg)](https://www.xkcd.com/)

Puzzle text/solution copyright <a href="https://www.xkcd.com/">Randall Munroe</a>, 2005-2006

</div>
