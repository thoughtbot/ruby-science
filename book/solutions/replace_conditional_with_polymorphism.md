## Replace Conditional with Polymorphism

Conditional code clutters methods, makes extraction and reuse harder and can
lead to leaky concerns. Object-oriented languages like Ruby allow developers to
avoid conditionals using polymorphism. Rather than using `if`/`else` or
`case`/`when` to create a conditional path for each possible situation, you can
implement a method differently in different classes, adding (or reusing) a class
for each situation.

Replacing conditional code allows you to move decisions to the best point in the
application. Depending on polymorphic interfaces will create classes that don't
need to change when the application changes.

### Uses

* Removes [divergent change](#divergent-change) from classes that need to alter
  their behavior based on the outcome of the condition.
* Prevents [shotgun surgery](#shotgun-surgery) from adding new types.
* Removes [feature envy](#feature-envy) by allowing dependent classes to make
  their own decisions.
* Makes it easier to remove [duplicated code](#duplicated-code) by taking
  behavior out of conditional clauses and private methods.
* Makes conditional logic easier to reuse, which makes it easier to [avoid
  duplication](#dry).
* Replaces conditional logic with simple commands, following [tell, don't
  ask](#tell-dont-ask).

### Example

This `Question` class summarizes its answers differently depending on its
`question_type`:

` app/models/question.rb@a53319f

There are a number of issues with the `summary` method:

* Adding a new question type will require modifying the method, leading to
  [divergent change](#divergent-change).
* The logic and data for summarizing every type of question and answer is jammed
  into the `Question` class, resulting in a [large class](#large-class) with
  [obscure code](#obscure-code).
* This method isn't the only place in the application where question
  types are checked, meaning that new types will cause [shotgun surgery](#shotgun-surgery).

There are several ways to refactor to use polymorphism. In this chapter, we'll
demonstrate a solution that uses subclasses to replace type codes, which is
one of the simplest solutions to implement. However, make sure to see the [Drawbacks](#drawbacks) section in this chapter for alternative
implementations.

### Replace Type Code with Subclasses

Let's replace this case statement with polymorphism by introducing a subclass
for each type of question.

Our `Question` class is a subclass of `ActiveRecord::Base`. If we want to create
subclasses of `Question`, we have to tell ActiveRecord which subclass to
instantiate when it fetches records from the `questions` table. The mechanism
Rails uses for storing instances of different classes in the same table is
called [single table inheritance](#single-table-inheritance-sti). Rails will
take care of most of the details, but there are a few extra steps we need to
take when refactoring to single table inheritance.

### Single Table Inheritance (STI)

The first step to convert to [STI](#single-table-inheritance-sti) is generally
to create a new subclass for each type. However, the existing type codes are
named "Open," "Scale" and "MultipleChoice," which won't make good class names. Names like "OpenQuestion" would be better, so let's start by changing the
existing type codes:

` app/models/question.rb@b535171:17,26

\clearpage

` db/migrate/20121128221331_add_question_suffix_to_question_type.rb@b535171

See [commit b535171] for the full change.

[commit b535171]: https://github.com/thoughtbot/ruby-science/commit/b535171

The `Question` class stores its type code as `question_type`. The Rails
convention is to use a column named `type`, but Rails will automatically start
using STI if that column is present. That means that renaming `question_type` to
`type` at this point would result in debugging two things at once: possible
breaks from renaming and possible breaks from using STI. Therefore, let's
start by just marking `question_type` as the inheritance column, allowing us to
debug STI failures by themselves:

` app/models/question.rb@c18ebeb:6

Running the tests after this will reveal that Rails wants the subclasses to be
defined, so let's add some placeholder classes:

` app/models/open_question.rb@c18ebeb

` app/models/scale_question.rb@c18ebeb

` app/models/multiple_choice_question.rb@c18ebeb

Rails generates URLs and local variable names for partials based on class names.
Our views will now be getting instances of subclasses like `OpenQuestion` rather
than `Question`, so we'll need to update a few more references. For example,
we'll have to change lines like:

``` erb
<%= form_for @question do |form| %>
```

To:

``` erb
<%= form_for @question, as: :question do |form| %>
```

Otherwise, it will generate `/open_questions` as a URL instead of `/questions`.
See [commit c18ebeb] for the full change.

[commit c18ebeb]: https://github.com/thoughtbot/ruby-science/commit/c18ebeb

At this point, the tests are passing with STI in place, so we can rename
`question_type` to `type`, following the Rails convention:

` db/migrate/20121128225425_rename_question_type_to_type.rb@5125668

Now we need to build the appropriate subclass instead of `Question`. We can use
a little Ruby meta-programming to make that fairly painless:

` app/controllers/questions_controller.rb@80deb8c:19,26

At this point, we're ready to proceed with a regular refactoring.

### Extracting Type-Specific Code

The next step is to move type-specific code from `Question` into the subclass
for each specific type.

Let's look at the `summary` method again:

` app/models/question.rb@a53319f:17,26

For each path of the condition, there is a sequence of steps.

The first step is to use [extract method](#extract-method) to move each path to
its own method. In this case, we already extracted methods called
`summarize_multiple_choice_answers`, `summarize_open_answers`, and
`summarize_scale_answers`, so we can proceed immediately.

The next step is to use [move method](#move-method) to move the extracted method
to the appropriate class. First, let's move the method
`summarize_multiple_choice_answers` to `MultipleChoiceQuestion` and rename it to
`summary`:

```` ruby
class MultipleChoiceQuestion < Question
  def summary
    total = answers.count
    counts = answers.group(:text).order('COUNT(*) DESC').count
    percents = counts.map do |text, count|
      percent = (100.0 * count / total).round
      "#{percent}% #{text}"
    end
    percents.join(', ')
  end
end
````

`MultipleChoiceQuestion#summary` now overrides `Question#summary`, so the
correct implementation will now be chosen for multiple choice questions.

Now that the code for multiple choice types is in place, we repeat the steps for
each other path. Once every path is moved, we can remove `Question#summary`
entirely.

In this case, we've already created all our subclasses, but you can use [extract
class](#extract-class) to create them if you're extracting each conditional path
into a new class.

You can see the full change for this step in [commit a08f801].

[commit a08f801]: https://github.com/thoughtbot/ruby-science/commit/a08f801

The `summary` method is now much better. Adding new question types is easier.
The new subclass will implement `summary` and the `Question` class doesn't need
to change. The summary code for each type now lives with its type, so no one
class is cluttered up with the details.

### Polymorphic Partials

Applications rarely check the type code in just one place. Running grep on our
example application reveals several more places. Most interestingly, the views
check the type before deciding how to render a question:

` app/views/questions/_question.html.erb@4f9bdfe:5,29

In the previous example, we moved type-specific code into `Question` subclasses.
However, moving view code would violate MVC (introducing [divergent
change](#divergent-change) into the subclasses) and, more importantly, it would
be ugly and hard to understand.

Rails has the ability to render views polymorphically. A line like this&mdash;

```` erb
<%= render @question %>
````

&mdash;will ask `@question` which view should be rendered by calling `to_partial_path`.
As subclasses of `ActiveRecord::Base`, our `Question` subclasses will return a
path based on their class name. This means that the above line will attempt to
render `open_questions/_open_question.html.erb` for an open question, and so on.

We can use this to move the type-specific view code into a view for each type:

` app/views/open_questions/_open_question.html.erb@8243493

You can see the full change in [commit 8243493].

[commit 8243493]: https://github.com/thoughtbot/ruby-science/commit/8243493

### Multiple Polymorphic Views

Our application also has different fields on the question form depending on the
question type. Currently, that also performs type-checking:

` app/views/questions/new.html.erb@8243493:6,15

We already used views like `open_questions/_open_question.html.erb` for showing
a question, so we can't just put the edit code there. Rails doesn't support
prefixes or suffixes in `render`, but we can do it ourselves easily enough:

` app/views/questions/new.html.erb@eeba19d:4

This will render `app/views/open_questions/_open_question_form.html.erb` for an
open question, and so on.

### Drawbacks

It's worth noting that, although this refactoring improved this particular
example, replacing conditionals with polymorphism is not without its drawbacks.

Using polymorphism like this makes it easier to add new types, because adding a
new type means that you just need to add a new class and implement the required
methods. Adding a new type won't require changes to any existing classes, and
it's easy to understand what the types are because each type is encapsulated
within a class.

However, this change makes it harder to add new behaviors. Adding a new behavior
will mean finding every type and adding a new method. Understanding the behavior
becomes more difficult because the implementations are spread out among the
types. Object-oriented languages lean toward polymorphic implementations, but
if you find yourself adding behaviors much more often than adding types, you
should look into using observers or visitors instead.

Using subclasses forces you to use inheritance instead of composition for reuse
and separation of concerns. See [composition over
inheritance](#composition-over-inheritance) for more on this subject.

Also, using STI has specific disadvantages. See the [chapter on
STI](#single-table-inheritance-sti) for details.

### Next Steps

* Check the new classes for [duplicated code](#duplicated-code) that can be
  pulled up into the superclass.
* Pay attention to changes that affect the new types, watching out for [shotgun
  surgery](#shotgun-surgery) that can result from splitting up classes.
