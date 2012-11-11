## Code Reviews

Our first step towards better code is to review it.

Have you ever sent an email with typos? Did you review what you wrote before
clicking "Send"? Reviewing your e-mails prevents mistakes and reviewing your
code does the same.

To make it easier to review code, always work in a feature branch. The branch
reduces the temptation to push unreviewed code or to wait too long to push code.

The first person who should review every line of your code is you. Before
committing new code, read each changed line. Try git techniques such as:

    git diff
    git add --patch
    git commit --verbose

Read more about these commands and find the short form of the `--patch` and
`--verbose` options in Unix manual pages:

    man git-diff
    man git-add
    man git-commit

On a Linux or BSD system, reviewing a diff, opening a man page, and commiting to
git will open vim. You can change your `$EDITOR` shell variable or you can learn
vim. We use vim for Rails development so we will include vim tips in the book.

Review a `git diff` by paging up with `Ctrl+f` and paging down with `Ctrl+b`. To
find the `--patch` option in the `git add` manual, type `/--patch`. To write
your commit message, type `i` to enter vim's "insert" mode, type [a good commit
message](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html),
type `esc`, and type `:x` to save and exit.

If you're working on a team, push your feature branch and invite your teammates
to review the changes via `git diff origin/master..HEAD`.

Team review reveals how understandable code is to someone other than the author.
Your team members' understanding now is a good indicator of your understanding
in the future.

However, what should you and your teammates look for during review?
