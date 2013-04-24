# Law of Demeter

The Law of Demeter was developed at Northeastern University. It's named after
the Demeter Project, which is itself named after Demeter, the Greek goddess of
the harvest. There is widespread disagreement as to its pronunciation, but the
correct pronunciation emphasises the second syllable; you can trust us on that.

The law states that:

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

## Multiple Dots

The most obvious violation of the Law of Demeter is "multiple dots;" that is, a
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

The `plan_price` method above violates the Law of Demeter by invoking `price` on
the return value of `plan`. The `price` method is not a method on `User`, its
parameter `discount_code`, its instantiated object `coupon`, or its direct
component `account`.

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

If you find yourself writing lots of delegators, consider changing the consumer
class to take a different object. For example, if you need to delegate lots of
`User` methods to `Account`, it's possible that the code referencing `User`
should actually reference an instance of `Account` instead.

\clearpage

## Multiple Assignments

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
parameter, instantiated object, or direct subcomponent.

## The Spirit of the Law

Although the letter of the Law of Demeter is rigid, the message is broader. The
goal is to avoid over-entangling a method with another object's dependencies.
This means that fixing a violation shouldn't be your objective; removing the
problem that caused the violation is a better idea. Here are a few tips to avoid
misguided fixes to Law of Demeter violations:

* Many delegate methods to the same object are an indicator that your object
  graph may be awkward.
* Delegate methods with prefixes (`Post#author_name`) are fine, but it's worth a
  check to see if you can remove the prefix. If not, make sure you didn't
  actually want a reference to the prefix object (`Post#author`).
* Avoid multiple prefixes for delegate methods, such as
  `User#account_plan_price`.
* Avoid assigning to instance variables to work around violations.

## Duplication

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
classes when the relationship is defined, and then knowledge of it spreads to
two more locations in `charge_for_plan`.

Like most duplication, each instance isn't too harmful, but in aggregate,
duplication will make refactoring slowly become impossible.

### Application

The following smells may cause or result from Law of Demeter violations:

* [Feature Envy](#feature-envy) from methods that reach through a dependency
  chain multiple times.
* [Shotgun Surgery](#shotgun-surgery) resulting from changes in the dependency
  chain.

You can use these solutions to follow the Law of Demeter:

* [Move Methods](#move-method) that reach through a dependency to the owner of
  that dependency.
* [Inject Dependencies](#inject-dependencies) so that methods have direct access
  to the dependencies that they need.
* [Inline Classes](#inline-class) that are adding hops to the dependency chain
  without providing enough value.
