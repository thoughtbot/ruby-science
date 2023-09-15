## DRY

The DRY principle&mdash;short for "don't repeat yourself"&mdash;comes from [The
Pragmatic Programmer](http://pragprog.com/book/tpp/the-pragmatic-programmer).

This principle states:

> Every piece of knowledge must have a single, unambiguous, authoritative
> representation within a system.

Following this principle is one of the best ways to prevent bugs and move
faster. Every duplicated piece of knowledge is a bug waiting to happen. Many
development techniques are really just ways to prevent and eliminate
duplication, and many smells are just ways to detect existing duplication.

When knowledge is duplicated, changing it means making the same change in
several places. Leaving duplication introduces a risk that the various duplicate
implementations will slowly diverge, making them harder to merge and making it
more likely that a bug remains in one or more incarnations after being fixed.

Duplication leads to frustration and paranoia. Rampant duplication is a common
reason that developers reach for a grand rewrite.

### Duplicated Knowledge vs. Duplicated Text

It's important to understand that this principle states that _knowledge_ should
not be repeated; it does not state that _text_ should never be repeated.

For example, this sample does not violate the DRY principle, even though the
word "save" is repeated several times:

``` ruby
def sign_up
  @user.save
  @account.save
  @subscription.save
end
```

However, this code contains duplicated knowledge that could be extracted:

``` ruby
def sign_up_free
  @user.save
  @account.save
  @trial.save
end

def sign_up_paid
  @user.save
  @account.save
  @subscription.save
end
```

### Application

The following smells may point toward [duplicated code](#duplicated-code) and
can be avoided by following the DRY principle:

* [Shotgun surgery](#shotgun-surgery) caused by changing the same knowledge in
  several places.
* [Long parameter lists](#long-parameter-list) caused by not encapsulating
  related properties.
* [Feature envy](#feature-envy) caused by leaking internal knowledge of a class
  that can be encapsulated and reused.

Making behavior easy to reuse is essential to avoiding duplication. Developers
won't be tempted to copy and paste something that's easy to reuse through a
small, easy to understand class or method. You can use these solutions to make
knowledge easier to reuse:

* [Extract classes](#extract-class) to encapsulate knowledge, allowing it to
  be reused.
* [Extract methods](#extract-method) to reuse behavior within a class.
* [Extract partials](#extract-partial) to remove duplication in views.
* [Extract validators](#extract-validator) to encapsulate validations.
* [Replace conditionals with null
  objects](#replace-conditional-with-null-object) to encapsulate behavior
  related to nothingness.
* [Replace conditionals with
  polymorphism](#replace-conditional-with-polymorphism) to make it easy to reuse
  behavioral branches.
* [Replace mixins with composition](#replace-mixin-with-composition) to make it
  easy to combine components in new ways.
* [Use convention over configuration](#use-convention-over-configuration) to
  infer knowledge, making it impossible to duplicate.

Applying these techniques before duplication occurs will make it less likely
that duplication will occur. To effectively prevent duplication, make knowledge
easier to reuse by keeping classes small and focused.

Related principles include the [Law of Demeter](#law-of-demeter) and the [single
responsibility principle](#single-responsibility-principle).
