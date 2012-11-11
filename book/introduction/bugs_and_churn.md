## Bugs and Churn

If it takes a long time to fix a bug, remove smells in the methods or classes
of the buggy code. You'll make it less likely that a bug will be reintroduced.

After you commit a bug fix to a feature branch, find out if the code you changed
to fix the bug is in files that change often:

    git log origin/master.. --name-only | grep '.rb' | sort | uniq -c | sort

If the buggy code changes often, find smells and refactor them. Separate the
parts that change often from the parts that don't.

Conversely, avoid refactoring areas with low churn. Refactoring changes code,
and with each change, you risk introducing new bugs. If a file hasn't changed
in six months, leave it alone. It may not be pretty, but you'll spend more
time looking at it when you break it trying to fix something that wasn't broken.
