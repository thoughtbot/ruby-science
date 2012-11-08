## Removing Resistance

There's another obvious opportunity for refactoring: any time you're having a
hard time introducing a change to existing code, consider refactoring the code
first. What you change will depend on what type of resistance you met.

Did you have a hard time understanding the code? If the result you wanted seemed
simple, but you couldn't figure out where to introduce it, the code isn't
readable enough. Refactor the code until it's obvious where your change belongs,
and it will make this change and every subsequent change easier. Refactor for
readability first.

Was it hard to change the code without breaking existing code? Change the
existing code to be more flexible. Add extension points or extract code to be
easier to reuse, and then try to introduce your change. Repeat this process
until the change you want is easy to introduce.

This work flow pairs well with fast branching systems like Git. First, create a
new branch and attempt to make your change without any refactoring. If the
change is difficult, make a work in progress commit, switch back to master, and
create a new branch for refactoring. Refactor until you fix the resistance you
met on your feature branch, and then rebase the feature branch on top of the
refactoring branch. If the change is easier now, you're good to go. If not,
switch back to your refactoring branch and try again.

Each change should be easy to introduce. If it's not, it's time to refactor.
