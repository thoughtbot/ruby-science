## Bugs and Churn

If you're spending a lot of time swatting bugs, you should consider refactoring
the buggy portions of code. After each bug is fixed, examine the methods and
classes you had to change to fix the bug. If you remove any smells you discover
in the affected areas, then you'll make it less likely that a bug will be
reintroduced.

Bugs tend to crop up in the same places over and over. These places also tend to
be the methods and classes with the highest rate of churn. When you find a bug,
use Git to see if the buggy file changes often. If so, try refactoring the
classes or methods which keep changing. If you separate the pieces that change
often from the pieces that don't, then you'll spend less time fixing existing
code. When you find files with high churn, look for smells in the areas that
keep changing. The smell may reveal the reason for the high churn.

Conversely, it may make sense to avoid refactoring areas with low churn.
Although refactoring is an important part of keeping your code sane, refactoring
changes code, and with each change, you risk introducing new bugs. Don't
refactor just for the sake of "cleaner" code; refactor to address real problems.
If a file hasn't changed in six months and you aren't finding bugs in it, leave
it alone. It may not be the prettiest thing in your code base, but you'll have
to spend more time looking at it when you break it while trying to fix something
that wasn't broken.
