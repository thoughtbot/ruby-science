## Code Reviews

The first step towards cleaner code is to make sure you read the code as you
write it. Have you ever typed up a long e-mail, hit "Send," and then realized
later that you made several typos? The problem here is obvious: you didn't read
what you'd written before sending it. Proofreading your e-mails will save you
from all kinds of embarrassments. Proofreading your code will do the same.

An easy way to make it simple to proofread code is to always work on a feature
branch.  Never commit directly to your master branch; doing so will make it
tempting to either push code that hasn't been reviewed, or keep code on your
local machine.  Neither is a good idea.

The first person who should look at every line of code you write is easy
to find: it's you! Before merging your feature branch, look at the diff of what
you've done. Read through each changed line, each new method, and each new
class to make sure that you like what you see.

If you're working on a team, there's another valuable step you can take here.
After working on the same piece of code for a while, it's easy to develop
tunnel vision. Getting a fresh and different perspective will help catch
mistakes early, so get your team members involved. After you view your new
code, don't merge your feature branch just yet. Push it up and invite your team
members to view the diff as well. When reviewing somebody else's code, take the
same approach you took above: page through the diff, and make sure you like
everything you see.

Another benefit provided by team code reviews is that you get immediate feedback
on how understandable a piece of code is. Chances are good that you'll
understand your own code. After all, you just wrote it. However, you want your
team members to understand your code as well. Also, even though the code is
clear now, it may not be as obvious looking over it again in six months. Your
team members will be a good indication of what your own understanding will be in
the future. If it doesn't make sense to them now, it won't make sense to you
later.

Code reviews provide an opportunity to catch mistakes and improve code before it
ever gets merged, but there's still a big question out there: what should you be
looking for?
