## Just Follow Your Nose

The primary motivator for refactoring is the code smell. A code smell is an
indicator that something may be wrong in the code. Not every smell means
that you should fix something; however, smells are useful because they're
easy to spot, and the root cause for a particular problem can be harder to track
down.

When performing code reviews, be on the lookout for smells. Whenever you see a
smell, think about whether or not it would be better if you changed the code to
remove the smell. If you're reviewing somebody else's code, suggest possible
ways to refactor the code which would remove the smell.

Don't treat code smells as bugs. Attempting to "fix" every smell you run across
will end up being a waste of time, as not every smell is the symptom of an
actual problem. Worse, removing code smells for the sake of process will end up
obfuscating code because of the unnecessary hoops you'll jump through. In the
end, it will prove impossible to remove every smell, as removing one smell will
often introduce another.

Each smell is associated with one or more common refactorings. If you see a long
method, the most common way to improve the method is to extract new, smaller
methods. Knowing the common refactorings that remove a smell will allow you to
quickly think about how the code might change. Knowing that long methods can be
removed by extracting methods, you can decide whether or not the end result of
having several methods will be better or worse.
