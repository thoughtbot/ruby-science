## Composition Over Inheritance

In class-based object-oriented systems, composition and inheritance are the two
primary methods of reusing and assembling components. Composition Over
Inheritance suggests that, when there isn't a strong case for using inheritance,
developers implement reuse and assembly using composition instead.

Let's look at a simple example implemented using both composition and
inheritance. In our example application, users can invite their friends to take
surveys. Users can be invited using either an email or an internal private
message. Each delivery strategy is implemented using a separate class.

### Inheritance

In the inheritance model, we use an abstract base class called `Inviter` to
implement common invitation-sending logic. We then use `EmailInviter` and
`MessageInviter` subclasses to implement the delivery details.

\clearpage

` app/models/inviter.rb@efca7623

` app/models/email_inviter.rb@efca7623

\clearpage

` app/models/message_inviter.rb@efca7623

Note that there is no clear boundary between the base class and the subclasses.
The subclasses access reusable behavior by invoking private methods inherited from the base class, like
`render_message_body`.

### Composition

In the composition model, we use a concrete `InvitationMessage` class to
implement common invitation-sending logic. We then use that class from
`EmailInviter` and `MessageInviter` to reuse the common behavior, and the
inviter classes implement delivery details.

` app/models/invitation_message.rb@3ff96b38

` app/models/email_inviter.rb@3ff96b38

` app/models/message_inviter.rb@3ff96b38

Note that there is now a clear boundary between the common behavior in
`InvitationMessage` and the variant behavior in `EmailInviter` and
`MessageInviter`. The inviter classes access reusable behavior by invoking
public methods like `body` on the shared class.

### Dynamic vs. Static

Although the two implementations are fairly similar, one difference between them
is that in the inheritance model the components are assembled statically. The composition model, on the other hand, assembles the components dynamically.

Ruby is not a compiled language and everything is evaluated at run-time, so
claiming that anything is assembled statically may sound like nonsense.
However, there are several ways in which inheritance hierarchies are essentially
written in stone, or static:

* You can't swap out a superclass once it's assigned.
* You can't easily add and remove behaviors after an object is instantiated.
* You can't inject a superclass as a dependency.
* You can't easily access an abstract class's methods directly.

On the other hand, everything in a composition model is dynamic:

* You can easily change out a composed instance after instantiation.
* You can add and remove behaviors at any time using decorators, strategies,
  observers and other patterns.
* You can easily inject composed dependencies.
* Composed objects aren't abstract, so you can use their methods anywhere.

### Dynamic Inheritance

There are very few rules in Ruby, so many of the restrictions that apply to
inheritance in other languages can be worked around in Ruby. For example:

* You can reopen and modify classes after they're defined, even while an
  application is running.
* You can extend objects with modules after they're instantiated to add
  behaviors.
* You can call private methods by using `send`.
* You can create new classes at run-time by calling `Class.new`.

These features make it possible to overcome some of the rigidity of inheritance
models. However, performing all of these operations is simpler with objects than
it is with classes, and doing too much dynamic type definition will make the
application harder to understand, by diluting the type system. After all, if none
of the classes are ever fully formed, what does a class represent?

### The Trouble with Hierarchies

Using subclasses introduces a subtle problem into your domain model: It assumes
that your models follow a hierarchy; that is, it assumes that your types fall
into a tree-like structure.

Continuing with the above example, we have a root type, `Inviter`, and two
subtypes, `EmailInviter` and `MessageInviter`. What if we want invitations sent
by admins to behave differently than invitations sent by normal users? We can
create an `AdminInviter` class, but what will its superclass be?  How will we
combine it with `EmailInviter` and `MessageInviter`? There's no easy way to
combine email, message and admin functionality using inheritance, so you'll end
up with a proliferation of conditionals.

Composition, on the other hand, provides several ways out of this mess, such as
using a decorator to add admin functionality to the inviter. Once you build
objects with a reasonable interface, you can combine them endlessly with minimal
modification to the existing class structure.

### Mixins

Mixins are Ruby's answer to multiple inheritance.

However, mixins need to be mixed into a class before they can be used. Unless
you plan on building dynamic classes at runtime, you'll need to create a class
for each possible combination of modules. This will result in a ton of little
classes, such as `AdminEmailInviter`.

Again, composition provides a clean answer to this problem, because you can create
as many anonymous combinations of objects as your little heart desires.

Ruby does allow dynamic use of mixins using the `extend` method. This technique
does work, but it has its own complications. Extending an object's type
dynamically in this way dilutes the meaning of the word "type," making it
harder to understand what an object is. Additionally, using runtime `extend` can
lead to performance issues in some Ruby implementations.

### Single Table Inheritance

Rails provides a way to persist an inheritance hierarchy, known as [Single Table
Inheritance](#single-table-inheritance-sti), often abbreviated as STI. Using
STI, a cluster of subclasses is persisted to the same table as the base class. The name of the subclass is also saved on the row, allowing Rails to instantiate
the correct subclass when pulling records back out of the database.

Rails also provides a clean way to persist composed structures using polymorphic
associations. Using a polymorphic association, Rails will store both the primary
key and the class name of the associated object.

Because Rails provides a clean implementation for persisting both inheritance
and composition, the fact that you're using ActiveRecord should have little
influence on your decision to design using inheritance versus composition.

### Drawbacks

Although composed objects are largely easy to write and assemble, there are
situations in which they hurt more than inheritance trees.

* Inheritance cleanly represents hierarchies. If you really do have a hierarchy
  of object types, use inheritance.
* Subclasses always know what their superclass is, so they're easy to
  instantiate. If you use composition, you'll need to instantiate at least two
  objects to get a usable instance: the composing object and the composed
  object.
* Using composition is more abstract, which means that you need a name for the
  composed object. In our earlier example, all three classes were "inviters" in
  the inheritance model, but the composition model introduced the "invitation
  message" concept. Excessive composition can lead to vocabulary overload.

### Application

If you see these smells in your application, they may be a sign that you should
switch some classes from inheritance to composition:

* [Divergent change](#divergent-change) caused by frequent leaks into abstract
  base classes.
* [Large classes](#large-class) acting as abstract base classes.
* [Mixins](#mixin) serving to allow reuse while preserving the appearance of a
  hierarchy.

Classes with these smells may be difficult to transition to a composition model:

* [Duplicated code](#duplicated-code) will need to be pulled up into the base
  class before subclasses can be switched to strategies.
* [Shotgun surgery](#shotgun-surgery) may represent tight coupling between base
  classes and subclasses, making it more difficult to switch to composition.

These solutions will help move from inheritance to composition:

* [Extract classes](#extract-class) to liberate private functionality from
  abstract base classes.
* [Extract method](#extract-method) to make methods smaller and easier to move.
* [Move method](#move-method) to slim down bloated base classes.
* [Replace mixins with composition](#replace-mixin-with-composition) to make it
  easier to dissolve hierarchies.
* [Replace subclasses with strategies](#replace-subclasses-with-strategies)
  to implement variations dynamically.

After replacing inheritance models with composition, you'll be free to use these
solutions to take your code further:

* [Extract decorators](#extract-decorator) to make it easy to add behaviors
  dynamically.
* [Inject dependencies](#inject-dependencies) to make it possible to compose
  objects in new ways.

Following this principle will make it much easier to follow the [dependency
inversion principle](#dependency-inversion-principle) and the [open/closed
principle](#openclosed-principle).
