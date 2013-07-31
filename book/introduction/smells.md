## Follow Your Nose

Code "smells" are indicators something may be wrong. They are useful because
they are easy to see—sometimes easier than the root cause of a problem.

When you review code, watch for smells. Consider whether refactoring the code to
remove the smell would result in better code. If you're reviewing a teammate's
feature branch, share your best refactoring ideas with him or her.

Smells are associated with one or more refactorings (example: remove the Long Method
smell using the Extract Method refactoring). Learn these associations in order
to quickly consider them during review and whether the result (example: several
small methods) improves the code.

Don't treat code smells as bugs. It will be a waste of time to "fix" every
smell. Not every smell is the symptom of a problem and despite your best
intentions, you can accidentally introduce another smell or problem.