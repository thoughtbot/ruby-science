## Single Responsibility Principle

The Single Responsibility Principle, often abbreviated as "SRP," was introduced
by Uncle Bob Martin, and states:

> A class should have only one reason to change.

Classes with fewer responsibilities are more likely to be reusable, easier to
understand and faster to test. They are easy to change and require fewer
changes after being written.

Although this appears to be a very simple principle, deciding whether or not
any two pieces of behavior introduce two reasons to change is difficult, and
obeying SRP rigidly can be frustrating.

### Reasons to Change

One of the challenges in identifying reasons to change is deciding what granularity to be concerned with.

In our example application, users can invite their friends to take surveys. When
an invitation is sent, we encapsulate that invitation in a basic ActiveRecord
subclass:

\clearpage

` app/models/invitation.rb@dcc40d60

Everything in this class has something to do with invitations. We could make
the blunt assessment that this class obeys SRP, because it will only change when
invitation-related functionality changes. However, looking more carefully at how
invitations are implemented, several other reasons to change can be identified:

* The format of invitation tokens changes.
* A bug is identified in our validation of email addresses.
* We need to deliver invitations using some mechanism other than email.
* Invitations need to be persisted in another way, such as in a NoSQL database.
* The API for ActiveRecord or ActiveSupport changes during an update.
* The application switches from Rails to a new framework.

That gives us half a dozen reasons this class might change, leading to the
probable conclusion that this class does not follow SRP. So, should this class
be refactored?

### Stability

Not all reasons to change are created equal.

As a developer, you can anticipate likely changes based on your
experience&mdash;or just common sense. For example, attributes and business
rules for invitations are likely to change, so we know that this class will
change as invitations evolve in the application.

Regular expressions are powerful but tricky beasts, so it's likely that we'll
have to adjust our regular expression. It might be nice to encapsulate that
somewhere else, such as in a [custom validator](#extract-validator).

It's not always helpful to speculate as to what delivery mechanisms may loom in the
distant future, but it's not out of the realm of possibility that we'll need to
send messages using an internal private messaging system, or another service like
Facebook or Twitter. Therefore, it may be worthwhile to use [dependency
injection](#inject-dependencies) to remove the details of delivery from this
model. This may also make testing easier and make the class easier to understand
as a unit, because it will remove distracting details relating to email
delivery.

NoSQL databases have their uses, but we have no reason to believe we'll ever
need to move these records into another type of database. ActiveRecord has
proven to be a safe and steady default choice, so it's probably not worth the
effort to protect ourselves against that change.

Some of our business logic is expressed using APIs from libraries that could
change, such as validations and relationships. We could write our own adapter to
protect ourselves from those changes, but the maintenance burden is unlikely to
be worth the benefit, and it will make the code harder to understand, since there
will be unnecessary indirection between the model and the framework.

Lastly, we could protect our application against framework changes by preventing
any business logic from leaking into the framework classes, such as controllers
and ActiveRecord models. Again, this would add a thick layer of indirection to
protect against an unlikely change.

However, if you're trying out a new database, object-relational mapper or
framework, it may be worth adding some increased protection. The first time you
use a new database, you may not be fully confident regarding that decision. Preventing any
business logic from mixing with the persistence logic will make it easier to undo that decision and revert to a familiar solution like
ActiveRecord in case the new database turns against you.

The less confident you are about a decision, the more you should isolate that
decision from the rest of your application.

### Cohesion

One of the primary goals of SRP is to promote cohesive classes. The more closely
related the methods and properties are to each other, the more cohesive a class
is.

Classes with high cohesion are easier to understand, because the pieces fit
naturally together. They're also easier to change and reuse, because they won't
be coupled to any unexpected dependencies.

Following this principle will lead to high cohesion, but it's important to focus
on the output of each change made to follow the principle. If you notice an
extra responsibility in a class, think about the benefits of extracting that
responsibility. If you think noticeably higher cohesion will be the result,
charge ahead. If you think it will simply be a way to spend an afternoon, make a
note of it and move on.

### Responsibility Magnets

Every application develops a few black holes that like to suck up as much
responsibility as possible, slowly turning into [God classes](#god-class).

`User` is a common responsibility magnet. Generally, each application has a
focal point in its user interface that sucks up responsibility as well. Our
example application's main feature allows users to answer questions on surveys,
so `Survey` is a natural junk drawer for behavior.

It's easy to get sucked into a responsibility magnet by falling prey to
"Just-One-More Syndrome." Whenever you're about to add a new behavior to an
existing class, first check the history of that class. If there are previous
commits that show developers attempting to pull functionality out of this class,
chances are good that it's a responsibility over-eater. Don't feed the problem;
add a new class instead.

### Tension with Tell, Don't Ask

Extracting reasons to change can make it harder to follow [tell, don't
ask](#tell-dont-ask).

For example, consider a `Purchase` model that knows how to charge a user:

``` ruby
class Purchase
  def charge
    purchaser.charge_credit_card(total_amount)
  end
end
```

This method follows [tell, don't ask](#tell-dont-ask), because we can simply tell any `Purchase`
to `charge`, without examining any state on the `Purchase`.

However, it violates the SRP, because `Purchase` has
more than one reason to change. If the rules around charging credit cards change
or the rules for calculating purchase totals change, this class will have to
change.

You can more closely adhere to SRP by extracting a new class for the `charge`
method:

``` ruby
class PurchaseProcessor
  def initialize(purchase, purchaser)
    @purchase = purchase
    @purchaser = purchaser
  end

  def charge
    @purchaser.charge_credit_card @purchase.total_amount
  end
end
```

This class can encapsulate rules around charging credit cards and remain immune
to other changes, thus following SRP. However, it now violates [tell, don't ask](#tell-dont-ask),
because it must ask the `@purchase` for its `total_amount` in order to place the
charge.

These two principles are often at odds with each other and you must make a
pragmatic decision about which direction works best for your own classes.

### Drawbacks

There are a number of drawbacks to following this principle too rigidly:

* As outlined above, following this principle may lead to violations of [tell,
  don't ask](#tell-dont-ask).
* This principle causes an increase in the number of classes, potentially
  leading to [shotgun surgery](#shotgun-surgery) and vocabulary overload.
* Classes that follow this principle may introduce additional indirection,
  making it harder to understand high-level behavior by looking at individual
  classes.

### Application

If you find yourself fighting any of these smells, you may want to refactor to
follow the SRP:

* [Divergent change](#divergent-change) doesn't exist in classes that follow
  this principle.
* Classes following this principle are easy to reuse, reducing the likelihood of
  [Duplicated code](#duplicated-code).
* [Large classes](#large-class) almost certainly have more than one reason to
  change. Following this principle eliminates most large classes.

Code containing these smells may need refactoring before it can follow this
principle:

* [Case statements](#case-statement) make this principle difficult to follow, as
  every case statement introduces a new reason to change.
* [Long methods](#long-method) make it harder to extract concerns, as behavior
  can only be moved once it's encapsulated in a small, cohesive method.
* [Mixins](#mixin), [Single-table inheritance](#single-table-inheritance-sti),
  and inheritance in general make it harder to follow this principle, as the
  boundary between parent and child class responsibilities is always fuzzy.

These solutions may be useful on the path towards SRP:

* [Extract classes](#extract-class) to move responsibilities to their own class.
* [Extract decorators](#extract-decorator) to layer responsibilities onto
  existing classes without burdening the class definition with that knowledge.
* [Extract validators](#extract-validator) to prevent classes from changing when
  validation rules change.
* [Extract value objects](#extract-value-object) to prevent rules about a type
  like currency or names from leaking into other business logic.
* [Extract methods](#extract-method) to make responsibilities easier to move.
* [Move methods](#move-method) to place methods in a more cohesive environment.
* [Inject dependencies](#inject-dependencies) to relieve classes of the burden
  of changing with their dependencies.
* [Replace mixins with composition](#replace-mixin-with-composition) to make it
  easier to isolate concerns.
* [Replace subclasses with strategies](#replace-subclasses-with-strategies) to
  make variations usable without their base logic.

Following [composition over inheritance](#composition-over-inheritance) and the
[dependency inversion principle](#dependency-inversion-principle) may make SRP easier to follow, as those principles make it easier to extract
responsibilities. Following this principle will make it easier to follow the
[open-closed principle](#openclosed-principle) but may introduce violations of
[tell, don't ask](#tell-dont-ask).
