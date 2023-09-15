## Open/Closed Principle

The Open/Closed Principle states that:

\raggedright

> Software entities (classes, modules, functions, etc.) should be open for
> extension, but closed for modification.

The purpose of this principle is to make it possible to change or extend the
behavior of an existing class without actually modifying the source code to that
class.

Making classes extensible in this way has a number of benefits:

* Every time you modify a class, you risk breaking it, along with all classes
  that depend on that class. Reducing churn in a class reduces bugs in that
  class.
* Changing the behavior or interface to a class means that you need to update
  any classes that depend on the old behavior or interface. Allowing per-use
  extensions to a class eliminates this domino effect.

### Strategies

It may sound appealing to never need to change existing classes again, but achieving
this is difficult in practice. Once you've identified an area that keeps
changing, there are a few strategies you can use to make it possible to extend
without modifications. Let's go through an example with a few of those
strategies.

In our example application, we have an `Invitation` class that can deliver
itself to an invited user:

` app/models/invitation.rb@9f5c145:17,20

However, we need a way to allow users to unsubscribe from these notifications.
We have an `Unsubscribe` model that holds the email addresses of users that
don't want to be notified.

The most direct way to add this check is to modify `Invitation` directly:

` app/models/invitation.rb@69f3470d:17,22

However, that would violate the [open/closed
principle](#openclosed-principle). Let's see how we can
introduce this change without violating the principle.

\clearpage

### Inheritance

One of the most common ways to extend an existing class without modifying it is
to create a new subclass.

We can use a new subclass to handle unsubscriptions:

` app/models/unsubscribeable_invitation.rb@bf1ba7d2

\clearpage

This can be a little awkward when trying to use the new behavior, though. For
example, we need to create an instance of this class, even though we want to
save it to the same table as `Invitation`:

` app/models/survey_inviter.rb@bf1ba7d2:31,43

This works adequately for creation, but using the ActiveRecord pattern, we'll end
up with an instance of `Invitation` instead, if we ever reload from the database.
That means that inheritance is easiest to use when the class we're extending
doesn't require persistence.

Inheritance also requires some [creativity in unit
tests](https://github.com/thoughtbot/ruby-science/commit/bf1ba7d2) to avoid
duplication.

\clearpage

### Decorators

Another way to extend an existing class is to write a decorator.

Using Ruby's `DelegateClass` method, we can quickly create decorators:

` app/models/unsubscribeable_invitation.rb@9084ee0c

The implementation is extremely similar to the subclass but it can now be
applied at run-time to instances of `Invitation`:

` app/models/survey_inviter.rb@9084ee0c:27,31

The unit tests can also be greatly simplified [using
stubs](https://github.com/thoughtbot/ruby-science/blob/9084ee0c/example_app/spec/models/unsubscribeable_invitation_spec.rb).

This makes it easier to combine with persistence. However, Ruby's
`DelegateClass` doesn't combine well with ActionPack's polymorphic URLs.

### Dependency Injection

This method requires more forethought in the class you want to extend, but
classes that follow [inversion of control](#inversion-of-control) can inject
dependencies to extend classes without modifying them.

We can modify our `Invitation` class slightly to allow client classes to inject
a mailer:

` app/models/invitation.rb@c98ed5e0:17,20

\clearpage

Now we can write a mailer implementation that checks to see if users are
unsubscribed before sending them messages:

` app/mailers/unsubscribeable_mailer.rb@c98ed5e0

And we can use dependency injection to substitute it:

` app/models/survey_inviter.rb@c98ed5e0:27,31

### Everything is Open

As you've followed along with these strategies, you've probably noticed that
although we've found creative ways to avoid modifying `Invitation`, we've had to
modify other classes. When you change or add behavior, you need to change or add
it somewhere. You can design your code so that most new or changed behavior
takes place by writing a new class, but something, somewhere in the existing
code will need to reference that new class.

It's difficult to determine what you should attempt to leave open when writing a
class. It's hard to know where to leave extension hooks without anticipating
every feature you might ever want to write.

Rather than attempting to guess what will require extension in the future, pay
attention as you modify existing code. After each modification, check to see if
there's a way you can refactor to make similar extensions possible without
modifying the underlying class.

Code tends to change in the same ways over and over, so by making each change
easy to apply as you need to make it, you're making the next change easier.

\clearpage

### Monkey Patching

As a Ruby developer, you probably know that one quick way to extend a class
without changing its source code is to use a monkey patch:

``` ruby
# app/monkey_patches/invitation_with_unsubscribing.rb
Invitation.class_eval do
  alias_method :deliver_unconditionally, :deliver

  def deliver
    unless unsubscribed?
      deliver_unconditionally
    end
  end

  private

  def unsubscribed?
    Unsubscribe.where(email: recipient_email).exists?
  end
end
```

Although monkey patching doesn't literally modify the class's source code, it
does modify the existing class. That means that you risk breaking it, and, potentially, all classes that depend on it. Since you're changing the original behavior,
you'll also need to update any client classes that depend on the old behavior.

In addition to all the drawbacks of directly modifying the original class,
monkey patches also introduce confusion, as developers will need to look in
multiple locations to understand the full definition of a class.

In short, monkey patching has most of the drawbacks of modifying the original
class without any of the benefits of following the [open/closed principle](#openclosed-principle).

### Drawbacks

Although following the [open/closed principle](#openclosed-principle) will make code easier to change, it may make
it more difficult to understand. This is because the gained flexibility requires
introducing indirection and abstraction. Although all of the three strategies
outlined in this chapter are more flexible than the original change, directly
modifying the class is the easiest to understand.

This principle is most useful when applied to classes with high reuse and
potentially high churn. Applying it everywhere will result in extra work and
more obscure code.

### Application

If you encounter the following smells in a class, you may want to begin
following this principle:

* [Divergent change](#divergent-change) caused by a lack of extensibility.
* [Large classes](#large-class) and [long methods](#long-method) which can be
  eliminated by extracting and injecting dependent behavior.

You may want to eliminate the following smells if you're having trouble
following this principle:

* [Case statements](#case-statement) make it hard to obey this principle, as you
  can't add to the case statement without modifying it.

You can use the following solutions to make code more compliant with this
principle:

* [Extract decorator](#extract-decorator) to extend existing classes without
  modification.
* [Inject dependencies](#inject-dependencies) to allow future extensions without
  modification.
