# Code Smells

Code "smells" are indicators something may be wrong. They are useful because
they are easy to see&mdash;sometimes easier than the root cause of a problem.

When you review code, watch for smells. Consider whether refactoring the code to
remove the smell would result in better code. If you're reviewing a teammate's
feature branch, share your best refactoring ideas with them.

Smells are associated with one or more refactorings (example: remove the Long Method
smell using the Extract Method refactoring). Learn these associations in order
to quickly consider them during review and whether the result (example: several
small methods) improves the code.

Don't treat code smells as bugs. It will be a waste of time to "fix" every
smell. Not every smell is the symptom of a problem and despite your best
intentions, you can accidentally introduce another smell or problem.

### Tools to Find Smells

Some smells are easy to find while you're reading code and change sets, but
other smells slip through the cracks without extra help.

Duplication is one of the hardest problems to find by hand. If you're using
diffs during code reviews, it will be invisible when you copy and paste
existing methods. The original method will be unchanged and won't show up in the
diff, so unless the reviewer knows and remembers that the original existed, they
won't notice that the copied method isn't just a new addition. Every duplicated
piece of code is a bug waiting to happen.

Churn is similarly invisible, in that each change will look fine, and only the
file's full history will reveal the smell.

Various tools are available which can aid you in your search for code smells.

Our favorite is [Code Climate](https://codeclimate.com/), which is a hosted tool
and will scan your code for issues every time you push to Git. Code Climate
attempts to locate hot spots for refactoring and assigns each class a simple A
through F grade. It identifies complexity, duplication, churn and code smells.

If you're unable to use a hosted service, there are gems you can use locally,
such as [metric_fu], [churn], [flog], [flay], and [reek]. These gems can
identify churn, complexity, duplication and smells.

[metric_fu]: https://github.com/metricfu/metric_fu
[churn]: https://github.com/danmayer/churn
[flog]: http://rubygems.org/gems/flog
[flay]: http://rubygems.org/gems/flay
[reek]: https://github.com/troessner/reek/wiki

Getting obsessed with the counts and scores from these tools will distract from
the actual issues in your code, but it's worthwhile to run them continually and
watch out for potential warning signs.
