## Inline Class

As an application evolves, new classes are introduced as new features are added
and existing code is refactored. [Extracting classes](#extract-class) will help keep existing classes maintainable and make it easier to add new features.
However, features can also be removed or simplified, and you'll inevitably find
that some classes just aren't pulling their weight. Removing dead-weight classes
is just as important as splitting up [large classes](#large-class); inlining
a class is the easiest way to remove it.

Inlining a class is straightforward:

* For each consumer class that uses the inlined class, inline or move each method
  from the inlined class into the consumer class.
* Remove the inlined class.

Note that this refactoring is difficult (and unwise!) if you have more than one
or two consumer classes.

### Uses

* Makes classes easier to understand by eliminating the number of methods,
  classes, and files developers need to look through.
* Eliminates [shotgun surgery](#shotgun-surgery) from changes that cascade
  through useless classes.
* Eliminates [feature envy](#feature-envy) when the envied class can be inlined
  into the envious class.

### Example

In our example application, users can create surveys and invite other users to
answer them. Users are invited by listing email addresses to invite.

Any email addresses that match up with existing users are sent using a private
message that the user will see the next time they sign in. Invitations to
unrecognized addresses are sent using email messages.

The `Invitation` model delegates to a different strategy class based on whether
or not its recipient email is recognized as an existing user:

` app/models/invitation.rb@5295aff8:17,23

We've decided that the private messaging feature isn't getting enough use, so
we're going to remove it. This means that all invitations will now be delivered
via email, so we can simplify `Invitation#deliver` to always use the same
strategy:

` app/models/invitation.rb@6b5273d:17,19

The `EmailInviter` class was useful as a strategy, but now that the strategy no
longer varies, it doesn't bring much to the table:

` app/models/email_inviter.rb@6b5273d

It doesn't handle any concerns that aren't already well-encapsulated by
`InvitationMessage` and `Mailer`, and it's only used once (in `Invitation`). We
can inline this class into `Invitation` and eliminate some complexity and
indirection from our application.

First, [let's inline the `EmailInviter#deliver`
method](https://github.com/thoughtbot/ruby-science/commit/dcc40d60) (and its
dependent variables from `EmailInviter#initialize`):

` app/models/invitation.rb@dcc40d60:17,20

Next, we can [delete `EmailInviter`
entirely](https://github.com/thoughtbot/ruby-science/commit/bc863108).

After inlining the class, it requires fewer jumps through methods, classes and
files to understand how invitations are delivered. Additionally, the application
is less complex, overall. Flog gives us a total complexity score of 424.7 after
this refactoring, down slightly from 427.6. That isn't a huge gain, but this was
an easy refactoring, and continually deleting or inlining unnecessary classes
and methods will have broader long-term effects.

### Drawbacks

* Attempting to inline a class with multiple consumers will likely introduce
  [duplicated code](#duplicated-code).
* Inlining a class may create [large classes](#large-class) and cause [divergent
  change](#divergent-change).
* Inlining a class will usually increase per-class or per-method complexity,
  even if it reduces total complexity.

### Next Steps

* Use [extract method](#extract-method) if any inlined methods introduced [long
  methods](#long-method).
* Use [extract class](#extract-class) if the merged class is a [large
  class](#large-class) or is suffering from [divergent
  change](#divergent-change).
