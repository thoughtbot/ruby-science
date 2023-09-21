## Code Reviews

Our first step toward better code is to review it.

Have you ever sent an email with typos? Did you review what you wrote before
clicking "Send"? Reviewing your e-mails prevents mistakes and reviewing your
code does the same.

To make it easier to review code, always work in a feature branch. The branch
reduces the temptation to push unreviewed code or to wait too long to push code.

The first person who should review every line of your code is you. Before
committing new code, read each changed line. Use git's `diff` and `--patch`
features to examine code before you commit. Read more about these features using
`git help add` and `git help commit`.

If you're working on a team, push your feature branch and invite your teammates
to review the changes via `git diff origin/main..HEAD`.

Team review reveals how understandable code is to someone other than the author.
Your team members' understanding now is a good indicator of your understanding
in the future.

However, what should you and your teammates look for during review?
