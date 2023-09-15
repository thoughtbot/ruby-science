## Extract Decorator

Decorators can be used to place new concerns on top of existing objects without
modifying existing classes. They combine best with small classes containing few
methods, and make the most sense when modifying the behavior of existing
methods, rather than adding new methods.

The steps for extracting a decorator vary depending on the initial state, but
they often include the following:

1. Extract a new decorator class, starting with the alternative behavior.
2. Compose the decorator in the original class.
3. Move state specific to the alternate behavior into the decorator.
4. Invert control, applying the decorator to the original class from its
  container, rather than composing the decorator from the original class.

It will be difficult to make use of decorators unless your application is
following [composition over inheritance](#composition-over-inheritance).

### Uses

* Eliminate [large classes](#large-class) by extracting concerns.
* Eliminate [divergent change](#divergent-change) and follow the [single
  responsibility principle](#single-responsibility-principle) by adding new
  behavior without introducing new concerns to existing classes.
* Prevent conditional logic from leaking by making decisions earlier.
* Extend existing classes without modifying them, following the [open/closed
  principle](#openclosed-principle).

### Example

In our example application, users can view a summary of the answers to each
question on a survey. By default, in order to prevent the summary from influencing a user's
own answers, users don't see summaries for questions they haven't answered yet. Users can click a link to override this decision and view the
summary for every question. This concern is mixed across several levels, and
introducing the change affects several classes. Let's see if we can refactor
our application to make similar changes easier in the future.

Currently, the controller determines whether or not unanswered questions should
display summaries:

` app/controllers/summaries_controller.rb@15f5b96e:17,27

It passes this decision into `Survey#summaries_using` as a hash containing
Boolean flag:

` app/controllers/summaries_controller.rb@15f5b96e:4

\clearpage

`Survey#summaries_using` uses this information to decide whether each question
should return a real summary or a hidden summary:

` app/models/survey.rb@6ef24105:12,20

This method is pretty dense. We can start by using [extract
method](#extract-method) to clarify and reveal complexity:

` app/models/survey.rb@15f5b96e:12,34

The `summary_or_hidden_answer` method reveals a pattern that's well-captured by
using a Decorator:

* There's a base case: returning the real summary for the question's answers.
* There's an alternative, or decorated, case: returning a summary with a hidden
  answer.
* The conditional logic for using the base or decorated case is unrelated to the
  base case: `answered_by` is only used for determining which path to take, and
  isn't used by to generate summaries.

As a Rails developer, this may seem familiar to you: Many pieces of Rack
middleware follow a similar approach.

Now that we've recognized this pattern, let's refactor to use a decorator.

#### Move Decorated Case to Decorator

Let's start by creating an empty class for the decorator and [moving one
method](#move-method) into it:

` app/models/unanswered_question_hider.rb@af2e8318

The method references a constant from `Survey`, so we moved that, too.

Now we update `Survey` to compose our new class:

` app/models/survey.rb@af2e8318:18,24

At this point, the [decorated path is contained within the decorator](https://github.com/thoughtbot/ruby-science/commit/af2e8318).

#### Move Conditional Logic Into Decorator

Next, we can move the conditional logic into the decorator. We've already
extracted this to its own method on `Survey`, so we can simply move this method
over:

` app/models/unanswered_question_hider.rb@9d0274f4:8,10

Note that the `answered_by` parameter was renamed to `user`. That's because the context is more specific now, so it's clear what role the user is playing.

` app/models/survey.rb@9d0274f4:18,25

#### Move Body Into Decorator

[There's just one summary-related method left in `Survey`](https://github.com/thoughtbot/ruby-science/commit/9d0274f4):
`summary_or_hidden_answer`. Let's move this into the decorator:

` app/models/unanswered_question_hider.rb@4fd00a88:4,10

` app/models/survey.rb@4fd00a88:10,18

[At this point](https://github.com/thoughtbot/ruby-science/commit/4fd00a88),
every other method in the decorator can be made private.

\clearpage

#### Promote Parameters to Instance Variables

Now that we have a class to handle this logic, we can move some of the
parameters into instance state. In `Survey#summaries_using`, we use the same
summarizer and user instance; only the question varies as we iterate through
questions to summarize. Let's move everything but the question into instance
variables on the decorator:

` app/models/unanswered_question_hider.rb@72801b57:4,15

` app/models/survey.rb@72801b57:10,15

[Our decorator now just needs a `question` to generate a
`Summary`](https://github.com/thoughtbot/ruby-science/commit/72801b57).

#### Change Decorator to Follow Component Interface

In the end, the component we want to wrap with our decorator is the summarizer,
so we want the decorator to obey the same interface as its component&mdash;the
summarizer. Let's rename our only public method so that it follows the
summarizer interface:

` app/models/unanswered_question_hider.rb@61ca6784:9

` app/models/survey.rb@61ca6784:12,13

[Our decorator now follows the component interface in
name](https://github.com/thoughtbot/ruby-science/commit/61ca6784)&mdash;but not
behavior. In our application, summarizers return a string that represents the
answers to a question, but our decorator is returning a `Summary` instead. Let's
fix our decorator to follow the component interface by returning just a string:

` app/models/unanswered_question_hider.rb@876ec976:9,15

` app/models/unanswered_question_hider.rb@876ec976:19,21

` app/models/survey.rb@876ec976:10,15

Our decorator now [follows the component
interface](https://github.com/thoughtbot/ruby-science/commit/876ec976).

That last method on the decorator (`hide_answer_to_question`) isn't pulling its
weight anymore: It just returns the value from a constant. Let's [inline
it](https://github.com/thoughtbot/ruby-science/commit/77b22c5a) to slim down our
class a bit:

` app/models/unanswered_question_hider.rb@77b22c5a:9,15

Now we have a decorator that can wrap any summarizer, nicely-factored and ready
to use.

#### Invert Control

Now comes one of the most important steps: We can [invert
control](#dependency-inversion-principle) by removing any reference to the
decorator from `Survey` and passing in an already-decorated summarizer.

The `summaries_using` method is simplified:

` app/models/survey.rb@256a9c92:10,14

Instead of passing the Boolean flag down from the controller, we can [make the
decision to decorate
there](https://github.com/thoughtbot/ruby-science/commit/256a9c92) and pass a
decorated or undecorated summarizer:

` app/controllers/summaries_controller.rb@256a9c92:2,15

This isolates the decision to one class and keeps the result of the decision
close to the class that makes it.

Another important effect of this refactoring is that the `Survey` class is now
reverted back to [the way it was before we started hiding unanswered question
summaries](https://github.com/thoughtbot/ruby-science/blob/d97f7856/example_app/app/models/survey.rb).
This means that we can now add similar changes without modifying `Survey` at
all.

### Drawbacks

* Decorators must keep up to date with their component interface. Our decorator
  follows the summarizer interface. Every decorator we add for this interface is
  one more class that will need to change any time we change the interface.
* We removed a concern from `Survey` by hiding it behind a decorator, but this
  may make it harder for a developer to understand how a `Survey` might return
  the hidden response text, since that text doesn't appear anywhere in that class.
* The component we decorated had the smallest possible interface: one public
  method. Classes with more public methods are more difficult to decorate.
* Decorators can modify methods in the component interface easily, but adding
  new methods won't work with multiple decorators without meta-programming like
  `method_missing`. These constructs are harder to follow and should be used
  with care.

### Next Steps

* It's unlikely that your automated test suite has enough coverage to check
  every component implementation with every decorator. Run through the
  application in a browser after introducing new decorators. Test and fix any
  issues you run into.
* Make sure that inverting control didn't push anything over the line into a
  [large class](#large-class).
