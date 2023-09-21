## Replace Subclasses with Strategies

Subclasses are a common method of achieving reuse and polymorphism, but
inheritance has its drawbacks. See [composition over
inheritance](#composition-over-inheritance) for reasons why you might decide to
avoid an inheritance-based model.

During this refactoring, we will replace the subclasses with individual strategy
classes. Each strategy class will implement a common interface. The original
base class is promoted from an abstract class to the composition root, which
composes the strategy classes.

This allows for smaller interfaces, stricter separation of concerns and easier
testing. It also makes it possible to swap out part of the structure, which, in an inheritance-based model, would require converting to a new type.

When applying this refactoring to an `ActiveRecord::Base` subclass,
[STI](#single-table-inheritance-sti) is removed, often in favor of a polymorphic
association.

### Uses

* Eliminates [large classes](#large-class) by splitting up a bloated base class.
* Converts [STI](#single-table-inheritance-sti) to a composition-based scheme.
* Makes it easier to change part of the structure by separating the parts that
  change from the parts that don't.

### Example

The `switch_to` method on `Question` changes the question to a new type. Any
necessary attributes for the new subclass are provided to the `attributes`
method.

` app/models/question.rb@8c929881:23,37

Using inheritance makes changing question types awkward for a number of reasons:

* You can't actually change the class of an instance in Ruby, so you need to
  return the instance of the new class.
* The implementation requires deleting and creating records, but part of the
  transaction (`destroy`) must execute before we can validate the new instance.
  This results in control flow using exceptions.
* It's hard to understand why this method is implemented the way it is, so other
  developers fixing bugs or refactoring in the future will have a hard time
  navigating it.

We can make this operation easier by using composition instead of inheritance.

This is a difficult change that becomes larger as more behavior is added to the
inheritance tree. We can make the change easier by breaking it down into smaller
steps, ensuring that the application is in a fully functional state with passing
tests after each change. This allows us to debug in smaller sessions and create
safe checkpoint commits that we can retreat to if something goes wrong.

#### Use Extract Class to Extract Non-Railsy Methods from Subclasses

The easiest way to start is by extracting a strategy class from each subclass
and moving (and delegating) as many methods as you can to the new class. There's
some class-level wizardry that goes on in some Rails features, like associations,
so let's start by moving simple, instance-level methods that aren't part of the
framework.

Let's start with a simple subclass: `OpenQuestion.`

Here's the `OpenQuestion` class using an STI model:

` app/models/open_question.rb@4939d3e3

We can start by creating a new strategy class:

``` ruby
class OpenSubmittable
end
```

When switching from inheritance to composition, you need to add a new word to
the application's vocabulary. Before, we had questions, and different subclasses
of questions handled the variations in behavior and data. Now, we're switching
to a model where there's only one question class, and the question will compose
_something_ that will handle the variations. In our case, that _something_ is a
"submittable." In our new model, each question is just a question, and every
question composes a submittable that decides how the question can be submitted. Thus, our first extracted class is called `OpenSubmittable,` extracted from
`OpenQuestion.`

Let's move our first method over to `OpenSubmittable`:

` app/models/open_submittable.rb@7747366a

And change `OpenQuestion` to delegate to it:

` app/models/open_question.rb@7747366a

Each question subclass implements the `score` method, so we repeat this process
for `MultipleChoiceQuestion` and `ScaleQuestion`. You can see the full change
for this step in the [example
app](https://github.com/thoughtbot/ruby-science/commit/7747366a12b3f6f21d0008063c5655faba8e4890).

At this point, we've introduced a parallel inheritance hierarchy. During a
longer refactor, things may get worse before they get better. This is one of
several reasons that it's always best to refactor in a branch, separately from
any feature work. We'll make sure that the parallel inheritance hierarchy is
removed before merging.

#### Pull Up Delegate Method into Base Class

After the first step, each subclass implements a `submittable` method to build
its parallel strategy class. The `score` method in each subclass simply
delegates to its submittable. We can now pull the `score` method up into the
base `Question` class, completely removing this concern from the subclasses.

First, we add a delegator to `Question`:

` app/models/question.rb@9c2ddc65:12

Then, we remove the `score` method from each subclass.

You can see this change in full in the [example
app](https://github.com/thoughtbot/ruby-science/commit/9c2ddc65e7248bab1f010d8a2c74c8f994a8b26d).

#### Move Remaining Common API into Strategies

We can now repeat the first two steps for every non-Railsy method that the
subclasses implement. In our case, this is just the `breakdown` method.

The most interesting part of this change is that the `breakdown` method requires
state from the subclasses, so the question is now provided to the submittable:

` app/models/multiple_choice_question.rb@db3658cd:14,16

\clearpage

` app/models/multiple_choice_submittable.rb@db3658cd:22,28

You can view this change in the [example
app](https://github.com/thoughtbot/ruby-science/commit/db3658cd1c4601c07f49a7c666f57c00f5c22ffd).

#### Move Remaining Non-Railsy Public Methods into Strategies

We can take a similar approach for the uncommon API; that is, public methods
that are only implemented in one subclass.

First, move the body of the method into the strategy:

` app/models/scale_submittable.rb@2bce7f7b:14,16

Then, add a delegator. This time, the delegator can live directly on the
subclass, rather than the base class:

` app/models/scale_question.rb@2bce7f7b:5,7

Repeat this step for the remaining public methods that aren't part of the Rails
framework. You can see the full change for this step in our [example app](https://github.com/thoughtbot/ruby-science/commit/2bce7f7b0812b417dc41af369d18b83e057419ac).

#### Remove Delegators from Subclasses

Our subclasses now contain only delegators, code to instantiate the submittable,
and framework code. Eventually, we want to completely delete these subclasses,
so let's start stripping them down. The delegators are easiest to delete, so
let's take them on before the framework code.

First, find where the delegators are used:

` app/views/multiple_choice_questions/_multiple_choice_question_form.html.erb@2bce7f7b

And change the code to directly use the strategy instead:

` app/views/multiple_choice_questions/_multiple_choice_question_form.html.erb@c7a61dad

You may need to pass the strategy in where the subclass was used before:

` app/views/questions/_form.html.erb@c7a61dad:4,8

We can come back to these locations later and see if we need to pass in the
question at all.

After fixing the code that uses the delegator, remove the delegator from the
subclass. Repeat this process for each delegator until they've all been removed.

You can see how we do this in the [example app](https://github.com/thoughtbot/ruby-science/commit/c7a61dadfed53b9d93b578064d982f22d62f7b8d).

#### Instantiate Strategy Directly from Base Class

If you look carefully at the `submittable` method from each question subclass,
you'll notice that it simply instantiates a class based on its own class name
and passes itself to the `initialize` method:

` app/models/open_question.rb@c7a61dad:2,4

This is a pretty strong convention, so let's apply some [convention over
configuration](#use-convention-over-configuration) and pull the method up into
the base class:

` app/models/question.rb@75075985:19,22

We can then delete `submittable` from each of the subclasses.

At this point, the subclasses contain only Rails-specific code, like associations
and validations.

You can see the full change in the [example app](https://github.com/thoughtbot/ruby-science/commit/75075985e6050e5c1008010855e75df14547890c).

Also, note that you may want to [scope the `constantize`
call](#scoping-constantize) in order to make the strategies easy for developers
to discover and close potential security vulnerabilities.

#### A Fork in the Road

At this point, we're faced with a difficult decision. At first glance, it seems as
though only associations and validations live in our subclasses, and we could
easily move those to our strategy. However, there are two major issues.

First, you can't move the association to a strategy class without making that
strategy an `ActiveRecord::Base` subclass. Associations are deeply coupled with
`ActiveRecord::Base` and they simply won't work in other situations.

Also, one of our submittable strategies has state specific to that strategy.
Scale questions have a minimum and maximum. These fields are only used by scale
questions, but they're on the questions table. We can't remove this pollution
without creating a table for scale questions.

There are two obvious ways to proceed:

* Continue without making the strategies `ActiveRecord::Base` subclasses. Keep
  the association for multiple choice questions and the minimum and maximum for
  scale questions on the `Question` class, and use that data from the strategy.
  This will result in [divergent change](#divergent-change) and probably a
  [large class](#large-class) on `Question`, as every change in the data
  required for new or existing strategies will require new behavior on
  `Question`.
* Convert the strategies to `ActiveRecord::Base` subclasses. Move the
  association and state specific to strategies to those classes. This involves
  creating a table for each strategy and adding a polymorphic association to
  `Question.` This will avoid polluting the `Question` class with future
  strategy changes, but is awkward right now, because the tables for multiple
  choice questions and open questions would contain no data except the primary
  key. These tables provide a placeholder for future strategy-specific data, but
  those strategies may never require any more data and until they do, the tables
  are a waste of queries and the developer's mental space.

In this example, we'll move forward with the second approach, because:

* It's easier with ActiveRecord. ActiveRecord will take care of instantiating
  the strategy in most situations if it's an association, and it has special
  behavior for associations using nested attribute forms.
* It's the easiest way to avoid [divergent change](#divergent-change) and [large
  classes](#large-class) in a Rails application. Both of these smells can cause
  problems that are hard to fix if you wait too long.

#### Convert Strategies to ActiveRecord Subclasses

Continuing with our refactor, we'll change each of our strategy classes to
inherit from `ActiveRecord::Base`.

First, simply declare that the class is a child of `ActiveRecord::Base`:

` app/models/open_submittable.rb@e4809cd4:1

Your tests will complain that the corresponding table doesn't exist, so create
it:

` db/migrate/20130131205432_create_open_submittables.rb@e4809cd4

Our strategies currently accept the question as a parameter to `initialize` and
assign it as an instance variable. In an `ActiveRecord::Base` subclass, we don't
control `initialize`, so let's change `question` from an instance variable to an
association and pass a hash:

` app/models/open_submittable.rb@e4809cd4

` app/models/question.rb@e4809cd4:19,22

Our strategies are now ready to use Rails-specific functionality, like
associations and validations.

View the full change on [GitHub](https://github.com/thoughtbot/ruby-science/commit/e4809cd43da76bf1e6b0933040bffd9cc3ea810c).

#### Introduce a Polymorphic Association

Now that our strategies are persistable using ActiveRecord, we can use them in a
polymorphic association. Let's add the association:

` app/models/question.rb@7d6e294e:9

And add the necessary columns:

` db/migrate/20130131203344_add_submittable_type_and_id_to_questions.rb@7d6e294e

We're currently defining a `submittable` method that overrides the association.
Let's change that to a method that will build the association based on the STI
type:

` app/models/question.rb@7d6e294e:20,23

Previously, the `submittable` method built the submittable on demand, but now
it's persisted in an association and built explicitly. Let's change our
controllers accordingly:

` app/controllers/questions_controller.rb@7d6e294e:33,37

View the full change on [GitHub](https://github.com/thoughtbot/ruby-science/commit/7d6e294ef8d0e427f83710f74448768da80af2d4).

#### Pass Attributes to Strategies

We're persisting the strategy as an association, but the strategies currently
don't have any state. We need to change that, since scale submittables need a
minimum and maximum.

Let's change our `build_submittable` method to accept attributes:

` app/models/question.rb@ecc8e7b01:20,23

We can quickly change the invocations to pass an empty hash, and we're back to
green.

Next, let's move the `minimum` and `maximum` fields over to the
`scale_submittables` table:

` db/migrate/20130131211856_move_scale_question_state_to_scale_submittable.rb@41b49f49:3,4

Note that this migration is [rather
lengthy](https://github.com/thoughtbot/ruby-science/blob/41b49f49706135572a1b907f6a4c9747fb8446bb/example_app/db/migrate/20130131211856_move_scale_question_state_to_scale_submittable.rb),
because we also need to move over the minimum and maximum values for existing
questions. The SQL in our example app will work on most databases, but is
cumbersome. If you're using PostgreSQL, you can handle the `down` method easier
using an `UPDATE FROM` statement.

Next, we'll move validations for these attributes over from `ScaleQuestion`:

` app/models/scale_submittable.rb@41b49f49:4,5

And change `ScaleSubmittable` methods to use those attributes directly, rather
than looking for them on `question`:

` app/models/scale_submittable.rb@41b49f49:15,17

We can pass those attributes in our form by using `fields_for` and
`accepts_nested_attributes_for`:

` app/views/scale_questions/_scale_question_form.html.erb@41b49f49

` app/models/question.rb@41b49f49:14

In order to make sure the `Question` fails when its submittable is invalid, we
can cascade the validation:

` app/models/question.rb@41b49f49:6

Now, we just need our controllers to pass the appropriate submittable parameters:

` app/controllers/questions_controller.rb@41b49f49:33,37

\clearpage

` app/controllers/questions_controller.rb@41b49f49:43,55

All behavior and state is now moved from `ScaleQuestion` to `ScaleSubmittable`,
and the `ScaleQuestion` class is completely empty.

You can view the full change in the [example app](https://github.com/thoughtbot/ruby-science/commit/41b49f49706135572a1b907f6a4c9747fb8446bb).

#### Move Remaining Railsy Behavior Out of Subclasses

We can now repeat this process for remaining Rails-specific behavior. In our
case, this is the logic to handle the `options` association for multiple choice
questions.

We can move the association and behavior over to the strategy class:

` app/models/multiple_choice_submittable.rb@662e50874:2,5

Again, we remove the `options` method which delegated to `question` and rely on
`options` being directly available. Then we update the form to use `fields_for`
and move the allowed attributes in the controller from `question` to
`submittable`.

At this point, every question subclass is completely empty.

You can view the full change in the [example app](https://github.com/thoughtbot/ruby-science/commit/662e50874a377f8050ea2ad1326a7a4e47125f86).

#### Backfill Strategies for Existing Records

Now that everything is moved over to the strategies, we need to make sure that
submittables exist for every existing question. We can write a quick backfill
migration to take care of that:

` db/migrate/20130207164259_backfill_submittables.rb@662e5087

We don't port over scale questions, because we took care of them in a [previous
migration](https://github.com/thoughtbot/ruby-science/blob/41b49f49706135572a1b907f6a4c9747fb8446bb/example_app/db/migrate/20130131211856_move_scale_question_state_to_scale_submittable.rb).

#### Pass the Type When Instantiating the Strategy

At this point, the subclasses are just dead weight. However, we can't delete
them just yet. We're relying on the `type` column to decide what type of
strategy to build, and Rails will complain if we have a `type` column without
corresponding subclasses.

Let's remove our dependence on that `type` column. Accept a `type` when building
the submittable:

` app/models/question.rb@a3b36db9f:23,26

And pass it in when calling:

` app/controllers/questions_controller.rb@a3b36db9f:35

[Full Change](https://github.com/thoughtbot/ruby-science/commit/a3b36db9f0ec2d66e0ec1e7732662732380e6fc8)

#### Always Instantiate the Base Class

Now we can remove our dependence on the STI subclasses by always building an
instance of `Question`.

In our controller, we change this line:

` app/controllers/questions_controller.rb@a3b36db9f:34

To this:

` app/controllers/questions_controller.rb@19ee3047f:34

We're still relying on `type` as a parameter in forms and links to decide what
type of submittable to build. Let's change that to `submittable_type`, which is
already available because of our polymorphic association:

` app/controllers/questions_controller.rb@19ee3047f:40

` app/views/questions/_form.html.erb@19ee3047f:2

We'll also need to revisit views that rely on [polymorphic
partials](#polymorphic-partials) based on the question type and change them to
rely on the submittable type instead:

` app/views/surveys/show.html.erb@19ee3047f:37,40

Now we can finally remove our `type` column entirely:

` db/migrate/20130207214017_remove_questions_type.rb@19ee3047f

[Full Change](https://github.com/thoughtbot/ruby-science/commit/19ee3047f57807f342cb7cefd1b6589aff15ea6b)

#### Remove Subclasses

Now for a quick, glorious change: those `Question` subclasses are entirely empty
and unused, so we can [delete
them](https://github.com/thoughtbot/ruby-science/commit/c6f0e545ae9b3da017b3318f2882cb40954213ee).

This also removes the parallel inheritance hierarchy that we introduced earlier.

At this point, the code is as good as we found it.

#### Simplify Type Switching

If you were previously switching from one subclass to another as we did to
change question types, you can now greatly simplify that code.

Instead of deleting the old question and cloning it with a merged set of old
generic attributes and new specific attributes, you can simply swap in a new
strategy for the old one.

` app/models/question.rb@5f4a14ff:37,46

Our new `switch_to` method is greatly improved:

* This method no longer needs to return anything, because there's no need to
  clone. This is nice because `switch_to` is no longer a mixed command and query method (i.e., it does
  something and returns something), but simply a command method (i.e., it
  just does something).
* The method no longer needs to delete the old question, and the new submittable
  is valid before we delete the old one. This means we no longer need to use
  exceptions for control flow.
* It's simpler and its code is obvious, so other developers will have no trouble
  refactoring or fixing bugs.

You can see the full change that resulted in our new method in the [example
app](https://github.com/thoughtbot/ruby-science/commit/5f4a14ff6c43bf5b846d1c58d7509861c6fe3ac1).

#### Conclusion

Our new, composition-based model is improved in a number of ways:

* It's easy to change types.
* Each submittable is easy to use independently of its question, reducing
  coupling.
* There's a clear boundary in the API for questions and submittables, making it
  easier to test&mdash;and less likely that concerns leak between the two.
* Shared behavior happens via composition, making it less likely that the base
  class will become a [large class](#large-class).
* It's easy to add new state without affecting other types, because
  strategy-specific state is stored on a table for that strategy.

You can view the entire refactor with all steps combined in the [example
app](https://github.com/thoughtbot/ruby-science/compare/4939d3e3c539c5caaa36400d75258cc3f3f4e7d8...5f4a14ff6c43bf5b846d1c58d7509861c6fe3ac1) to get an idea of what changed at the macro level.

This is a difficult transition to make, and the more behavior and data that you
shove into an inheritance scheme, the harder it becomes. Regarding situations in which [STI](#single-table-inheritance-sti) is not significantly easier than using a
polymorphic relationship, it's better to start with composition. STI provides
few advantages over composition, and it's easier to merge models than to split
them.

### Drawbacks

Our application also got worse in a number of ways:

* We introduced a new word into the application vocabulary. This can increase
  understanding of a complex system, but vocabulary overload makes simpler
  systems unnecessarily hard to learn.
* We now need two queries to get a question's full state, and we'll need to
  query up to four tables to get information about a set of questions.
* We introduced useless tables for two of our question types. This will happen
  whenever you use ActiveRecord to back a strategy without state.
* We increased the overall complexity of the system. In this case, it may have
  been worth it, because we reduced the complexity per component. However, it's
  worth keeping an eye on.

Before performing a large change like this, try to imagine what currently difficult changes will be easier to
make in the new version.

After performing a large change, keep track of difficult changes you make. Would
they have been easier in the old version?

Answering these questions will increase your ability to judge whether or not to
use composition or inheritance in future situations.

### Next Steps

* Check the extracted strategy classes to make sure they don't have [feature
  envy](#feature-envy) related to the original base class. You may want to use
  [move method](#move-method) to move methods between strategies and the root
  class.
* Check the extracted strategy classes for [duplicated code](#duplicated-code)
  introduced while splitting up the base class. Use [extract
  method](#extract-method) or [extract class](#extract-class) to extract common
  behavior.
