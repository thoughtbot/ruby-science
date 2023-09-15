## Mixin

Inheritance is a common method of reuse in object-oriented software. Ruby
supports single inheritance using subclasses and multiple inheritance using
Mixins. Mixins can be used to package common helpers or provide a common public
interface.

However, mixins have some drawbacks:

* They use the same namespace as classes they're mixed into, which can cause
  naming conflicts.
* Although they have access to instance variables from classes they're mixed
  into, mixins can't easily accept initializer arguments, so they can't have
  their own state.
* They inflate the number of methods available in a class.
* They're not easy to add and remove at runtime.
* They're difficult to test in isolation, since they can't be instantiated.

### Symptoms

* Methods in mixins that accept the same parameters over and over.
* Methods in mixins that don't reference the state of the class they're mixed
  into.
* Business logic that can't be used without using the mixin.
* Classes that have few public methods except those from a mixin.
* [Inverting dependencies](#dependency-inversion-principle) is difficult because
  mixins can't accept parameters.

### Example

In our example application, users can invite their friends by email to take
surveys. If an invited email matches an existing user, a private message will be
created. Otherwise, a message is sent to that email address with a link.

The logic to generate the invitation message is the same regardless of the
delivery mechanism, so this behavior is encapsulated in a mixin:

` app/models/inviter.rb@37f9d40

\clearpage

Each delivery strategy mixes in `Inviter` and calls `render_message_body`:

` app/models/message_inviter.rb@37f9d40

Although the mixin does a good job of preventing [duplicated
code](#duplicated-code), it's difficult to test or understand in isolation, it
obfuscates the inviter classes, and it tightly couples the inviter classes to a
particular message body implementation.

### Solutions

* [Extract class](#extract-class) to liberate business logic trapped in mixins.
* [Replace mixin with composition](#replace-mixin-with-composition) to improve
  testability, flexibility and readability.

### Prevention

Mixins are a form of inheritance. By following [composition over
inheritance](#composition-over-inheritance), you'll be less likely to introduce
mixins.

Reserve mixins for reusable framework code like common associations and
callbacks, and you'll end up with a more flexible and comprehensible system.
