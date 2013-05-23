# DRY

The DRY principle - short for "don't repeat yourself" - comes from [The
Pragmatic Programmer](http://pragprog.com/book/tpp/the-pragmatic-programmer).

The principle states:

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
reason that developers reach for a Grand Rewrite.

## Duplicated Knowledge vs Duplicated Text

It's important to understand that this principle states that knowledge should
not be repeated; it does not state that text should never be repeated.

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

The following smells may point towards [duplicated code](#duplicated-code) and
can be avoided by following the DRY principle:

* [Shotgun Surgery](#shotgun-surgery) caused by changing the same knowledge in
  several places.
* [Long Paramter Lists](#long-parameter-list) caused by not encapsulating
  related properties.
* [Feature Envy](#feature-envy) caused by leaking internal knowledge of a class
  that can be encapsulated and reused.

You can use these solutions to remove duplication and make knowledge easier to
reuse:

* [Extract Classes](#extract-class) to encapsulate knowledge, allowing it to
  be reused.
* [Extract Methods](#extract-method) to reuse behavior within a class.
* [Extract Partials](#extract-partial) to remove duplication in views.
* [Extract Validators](#extract-validator) to encapsulate validations.
* [Replace Conditionals with Null
  Objects](#replace-conditional-with-null-object) to encapsulate behavior
  related to nothingness.
* [Replace Conditionals With
  Polymorphism](#replace-conditional-with-polymorphism) to make it easy to reuse
  behavioral branches.
* [Replace Mixins With Composition](#replace-mixin-with-composition) to make it
  easy to combine components in new ways.
* [Use Convention Over Configuration](#use-convention-over-configuration) to
  infer knowledge, making it impossible to duplicate.

Applying these techniques before duplication occurs will make it less likely
that duplication will occur. If you want to prevent duplication, make knowledge
easier to reuse by keeping classes small and focused.

Related principles include the [Law of Demeter](#law-of-demeter) and the [Single
Responsibility Principle](#single-responsibility-principle).
