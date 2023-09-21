## Removing Resistance

Another opportunity for refactoring is when you're having difficulty making
a change to existing code. This is called "resistance." The refactoring you
choose depends on the type of resistance.

Is it hard to determine where new code belongs? The code is not readable enough.
Rename methods and variables until it's obvious where your change belongs. This
and every subsequent change will be easier. Refactor for readability first.

Is it hard to change the code without breaking existing code? Add extension
points or extract code to be easier to reuse, and then try to introduce your
change. Repeat this process until the change you want is easy to introduce.

Each change should be easy to introduce. If it's not, refactor.

When you are making your changes, you will be in a feature branch. Try to make
your change without refactoring. If you meet resistance, make a "work in
progress" commit, check out main and create a new refactoring branch:

    git commit -m 'wip: new feature'
    git push
    git checkout main
    git checkout -b refactoring-for-new-feature

Refactor until you fix the resistance you met on your feature branch. Then
rebase your feature branch on top of your refactoring branch:

    git rebase -i new-feature
    git checkout new-feature
    git merge refactoring-for-new-feature --ff-only

If the change is easier now, continue in your feature branch. If not, check out
your refactoring branch and try again.
