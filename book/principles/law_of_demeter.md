## Law of Demeter

The Law of Demeter was developed at Northeastern University. It's named after
the Demeter Project, which was named after Demeter, the Greek goddess of
the harvest. There is widespread disagreement as to its pronunciation, but the
correct pronunciation emphasizes the second syllable; you can trust us on that.

This principle states that:

> A method of an object should invoke only the methods of the following kinds of
> objects:
>
> 1. itself
> 2. its parameters
> 3. any objects it creates/instantiates
> 4. its direct component objects

Like many principles, the Law of Demeter is an attempt to help developers manage
dependencies. The law restricts how deeply a method can reach into another
object's dependency graph, preventing any one method from becoming tightly
coupled to another object's structure.

### Multiple Dots

The most obvious violation of the Law of Demeter is "multiple dots," meaning a
chain of methods being invoked on each others' return values.

Example:

``` ruby
class User
  def discounted_plan_price(discount_code)
    coupon = Coupon.new(discount_code)
    coupon.discount(account.plan.price)
  end
end
```

The call to `account.plan.price` above violates the Law of Demeter by invoking
`price` on the return value of `plan`. The `price` method is not a method on
`User`, its parameter `discount_code`, its instantiated object `coupon` or its
direct component `account`.

The quickest way to avoid violations of this nature is to delegate the method:

``` ruby
class User
  def discounted_plan_price(discount_code)
    account.discounted_plan_price(discount_code)
  end
end

class Account
  def discounted_plan_price(discount_code)
    coupon = Coupon.new(discount_code)
    coupon.discount(plan.price)
  end
end
```

In a Rails application, you can quickly delegate methods using ActiveSupport's
`delegate` class method:

``` ruby
class User
  delegate :discounted_plan_price, to: :account
end
```

If you find yourself writing lots of delegators, consider changing the consumer
class to take a different object. For example, if you need to delegate numerous
`User` methods to `Account`, it's possible that the code referencing `User`
should actually reference an instance of `Account` instead.

### Multiple Assignments

Law of Demeter violations are often hidden behind multiple assignments.

``` ruby
class User
  def discounted_plan_price(discount_code)
    coupon = Coupon.new(discount_code)
    plan = account.plan
    coupon.discount(plan.price)
  end
end
```

The above `discounted_plan_price` method no longer has multiple dots on one
line, but it still violates the Law of Demeter, because `plan` isn't a
parameter, instantiated object or direct subcomponent.

### The Spirit of the Law

Although the letter of the Law of Demeter is rigid, its message is broader. The
fundamental goal is to avoid over-entangling a method with another object's dependencies.

This means that fixing a violation shouldn't be your objective; removing the
problem that _caused_ the violation is a better idea. Here are a few tips to avoid
misguided fixes to Law of Demeter violations:

* Many delegate methods to the same object are an indicator that your object
  graph may not accurately reflect the real-world relationships they represent.
* Delegate methods with prefixes (`Post#author_name`) are fine, but it's worth a
  check to see if you can remove the prefix. If not, make sure you didn't
  actually want a reference to the prefix object (`Post#author`).
* Avoid multiple prefixes for delegate methods, such as
  `User#account_plan_price`.
* Avoid assigning to instance variables to work around violations.

### Objects vs. Types

The version of the Law quoted at the beginning of this chapter is the "object
formulation," from the original paper. The first formulation was expressed in
terms of types:

> For all classes C, and for all methods M attached to C, all objects to which M
> sends a message must be instances of classes associated with the following
> classes:
>
> 1. The argument classes of M (including C).
> 2. The instance variable classes of C.
>
> (Objects created by M, or by functions or methods which M calls, and objects
> in global variables are considered as arguments of M.)

This formulation allows some more freedom when chaining using a fluent syntax.
Essentially, it allows chaining as long as each step of the chain returns the
same type.

Examples:

``` ruby
# Mocking APIs
user.should_receive(:save).once.and_return(true)

# Ruby's Enumerable
users.select(&:active?).map(&:name)

# String manipulation
collection_name.singularize.classify.constantize

# ActiveRecord chains
users.active.without_posts.signed_up_this_week
```

### Duplication

The Law of Demeter is related to the [DRY](#dry) principle, in that Law of
Demeter violations frequently duplicate knowledge of dependencies.

Example:

``` ruby
class CreditCardsController < ApplicationController
  def charge_for_plan
    if current_user.account.credit_card.valid?
      price = current_user.account.plan.price
      current_user.account.credit_card.charge price
    end
  end
end
```

In this example, the knowledge that a user has a credit card through its account
is duplicated. That knowledge is declared somewhere in the `User` and `Account`
classes when the relationship is defined, and knowledge of it then spreads to
two more locations in `charge_for_plan`.

Like most duplication, each instance isn't too harmful; but in aggregate,
duplication will slowly make refactoring become impossible.

### Application

The following smells may cause or result from Law of Demeter violations:

* [Feature envy](#feature-envy) from methods that reach through a dependency
  chain multiple times.
* [Shotgun surgery](#shotgun-surgery) resulting from changes in the dependency
  chain.

You can use these solutions to follow the Law of Demeter:

* [Move methods](#move-method) that reach through a dependency to the owner of
  that dependency.
* [Inject dependencies](#inject-dependencies) so that methods have direct access
  to the dependencies that they need.
* [Inline class](#inline-class) if it adds hops to the dependency chain without
  providing enough value.
