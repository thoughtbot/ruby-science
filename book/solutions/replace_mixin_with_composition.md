# Replace mixin with composition

Mixins are one of two mechanisms for inheritance in Ruby. This refactoring
provides safe steps for cleanly removing mixins that have become troublesome.

Removing a mixin in favor of composition involves the following steps:

* Extract a class for the mixin.
* Compose and delegate to the extracted class from each mixed in method.
* Replace references to mixed in methods with references to the composed class.
* Remove the mixin.

### Uses

* Liberate business logic trapped in mixins.
* Eliminate name clashes from multiple mixins.
* Make methods in the mixins easier test.

\clearpage

### Example

In our example applications, invitations can be delivered either by email or
private message (to existing users). Each invitation method is implemented in
its own class:

` app/models/message_inviter.rb@37f9d40

` app/models/email_inviter.rb@37f9d40

The logic to generate the invitation message is the same regardless of the
delivery mechanism, so this behavior has been extracted.

\clearpage

It's currently extracted using a mixin:

` app/models/inviter.rb@37f9d40

Let's replace this mixin with composition.

First, we'll [extract a new class](#extract-class) for the mixin:

` app/models/invitation_message.rb@8df463c4

This class contains all the behavior the formerly resided in the mixin. In order
to keep everything working, we'll compose and delegated to the extracted class
from the mixin:

` app/models/inviter.rb@8df463c4

Next, we can replace references to the mixed in methods (`render_message_body`
in this case) with direct references to the composed class:

` app/models/message_inviter.rb@4934a2f3

` app/models/email_inviter.rb@4934a2f3

In our case, there was only one method to move. If your mixin has multiple
methods, it's best to move them one at a time.

Once every reference to a mixed in method is replaced, you can remove the mixed
in method. Once every mixed in method is removed, you can remove the mixin
entirely.

### Next Steps

* [Inject Dependencies](#inject-dependencies) to invert control and allow the
  composing classes to use different implementations for the composed class.
* [Inline the composed class](#inline-class) if there's only one reference to it
  and it largely shares state with the composing class.
* Check the composing class for [Feature Envy](#feature-envy) of the extracted
  class. Tight coupling is common between mixin methods and host methods, so you
  may need to use [move method](#move-method) a few times to get the balance
  right.
