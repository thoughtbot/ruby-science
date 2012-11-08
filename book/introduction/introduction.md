After almost a decade of building applications with Ruby on Rails, the Rails
community has developed a number of principles to keep applications fast, fun,
and easy to change: Don't Repeat Yourself. Keep your views dumb. Keep your
controllers skinny. Keep business logic in your models. Write tests first. These
principles carry most applications to their first release or beyond.

However, these principles only get you so far. After a few releases, most
applications begin to suffer. Models become fat, classes become few and large,
tests become slow, and changes become painful. In many applications, there
comes a day when the developers realize that there's no going back; the
application is a twisted mess, and the only way out is a rewrite or a new job.

Fortunately, it doesn't have to be this way. Developers have been using
object-oriented programming for several decades, and there's a wealth of
knowledge out there which still applies to developing applications today. We can
use the lessons learned by these developers to write good Rails applications by
applying good object-oriented programming.

This book will outline a process for detecting emerging problems in code, and
will dive into the solutions, old and new.
