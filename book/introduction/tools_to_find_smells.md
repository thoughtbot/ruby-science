## Tools to Find Smells

Various tools are available which can aid you in your search for code smells.

While the churn, flog, flay, and reek gems can identify churn, complexity,
duplication, and smells, [prefer cloud services over
software](https://gist.github.com/adamwiggins/5687294). Unburden yourself
from the various problems of running code on your local machine such as
debugging code smell tools instead of debugging your app.

[Code Climate](https://codeclimate.com/) is a hosted tool which will scan your
code for issues every time you push to Git.  Code Climate attempts to locate hot
spots for refactoring and assigns each class a simple A through F grade. It
identifies complexity, duplication, churn, and code smells.

Duplication is one of the hardest problems to find by hand. If you're using
diffs during code reviews, it will be invisible when you copy and paste
existing methods. The original method will be unchanged and won't show up in the
diff, so unless the reviewer knows and remembers that the original existed, they
won't notice that the copied method isn't just a new addition. Every duplicated
piece of code is a bug waiting to happen.

Getting obsessed with the counts and scores from these tools will distract from
the actual issues in your code, but it's worthwhile to run them continually and
watch out for potential warning signs.
