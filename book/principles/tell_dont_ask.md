# Tell, Don't Ask

The Tell, Don't Ask principle advises developers to tell objects what you want
done, rather than querying objects and making decisions for them.

Consider the following example:

``` ruby
class Order
  def charge(user)
    if user.has_valid_credit_card?
      user.charge(total)
    else
      false
    end
  end
end
```

This example doesn't follow Tell, Don't Ask. It first asks the user if it has a
valid credit card, and then makes a decision based on the user's state.

In order to follow Tell, Don't Ask, we can move this decision into
`User#charge`:

\clearpage

``` ruby
class User
  def charge(total)
    if has_valid_credit_card?
      payment_gateway.charge(credit_card, total)
      true
    else
      false
    end
  end
end
```

Now `Order#charge` can just delegate to `User#charge`, passing its own relevant
state (`total`):

``` ruby
class Order
  def charge(user)
    user.charge(total)
  end
end
```

Following this principle has a number of benefits.

### Encapsulation of Logic

Following Tell, Don't Ask encapsulates the conditions under which an operation
can be performed in one place. In the above example, `User` should know when it
makes sense to `charge`.

### Encapsulation of State

Referencing another object's state directly couples two objects together based
on what they are, rather than just what they do. By following Tell, Don't Ask,
you encapsulate state within the object that uses it, exposing only the
operations that can be performed based on that state, and hiding the state
itself within private methods and instance variables.

### Minimal Public Interface

In many cases, following Tell, Don't Ask will result in the smallest possible
public interface between classes. In the above example, `has_valid_credit_card?`
can now be made private, because it becomes an internal concern encapsulated
within `User`.

Public methods are a liability. Before they can be changed, moved, renamed, or
removed, you need to find every consumer class and update them accordingly.

## Tension with MVC

This principle can be difficult to follow while also following MVC.

Consider a view that uses the above `Order` model:

``` rhtml
<%= form_for @order do |form| %>
  <% unless current_user.has_valid_credit_card? %>
    <%= render 'credit_card/fields', form: form %>
  <% end %>
  <!-- Order Fields -->
<% end %>
```

The view doesn't display the credit card fields if the user already has a valid
credit card saved. The view needs to ask the user a question and then change its
behavior based on that question, violating Tell, Don't Ask.

You could obey Tell, Don't Ask by making the user know how to render the credit
card form:

``` rhtml
<%= form_for @order do |form| %>
  <%= current_user.render_credit_card_form %>
  <!-- Order Fields -->
<% end %>
```

However, this violates MVC by including view logic in the `User` model. In this
case, it's better to keep the model, view, and controller concerns separate and
step across the Tell, Don't Ask line.

When writing interactions between other models and support classes, though, make
sure to give commands whenever possible, and avoid deviations in behavior based
on another class's state.

### Application

These smells may be a sign that you should be following Tell, Don't Ask more:

* [Feature Envy](#feature-envy) is frequently a sign that a method or part of a
  method should be extracted and moved to another class, reducing the number of
  questions that method must ask of another object.
* [Shotgun Surgery](#shotgun-surgery) may result from state and logic leaks.
  Consolidating conditionals using Tell, Don't Ask may reduce the number of
  changes required for new functionality.

If you find classes with these smells, they may require refactoring before you
can follow Tell, Don't Ask:

* [Case Statements](#case-statement) that inflect on methods from another object
  generally get in the way.
* [Mixins](#mixin) blur the lines between responsibilities, as mixed in methods
  operate on the state of the objects they're mixed into.

If you're trying to refactor classes to follow Tell, Don't Ask, these solutions
may be useful:

* [Extract Method](#extract-method) to encapsulate multiple conditions into one.
* [Move Method](#move-method) to move methods closer to the state they operate
  on.
* [Inline Class](#inline-class) to remove unnecessary questions between two
  classes with highly cohesive behavior.
* [Relace Conditionals with
  Polymorphism](#replace-conditional-with-polymorphism) to reduce the number of
  questions being asked around a particular operation.
* [Replace Conditionals with Null Object](#replace-conditional-with-null-object)
  to remove checks for `nil`.

Many [Law of Demeter](#law-of-demeter) violations point towards violations of
Tell, Don't Ask. Following Tell, Don't Ask may lead to violations of the [Single
Responsibility Principle](#single-responsibility-principle) and the [Open/Closed
Principle](#openclosed-principle), as moving operations onto the best class may
require modifying an existing class and adding a new responsibility.
