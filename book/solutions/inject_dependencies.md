## Inject Dependencies

Injecting dependencies allows you to keep dependency resolutions close to the
logic that affects them. It can prevent sub-dependencies from leaking throughout
the code base, and it simplifies changing the behavior of related
components [without modifying those components'
classes](#openclosed-principle).

Although many people think of dependency injection frameworks and XML when they
hear "dependency injection," injecting a dependency is usually as simple as
passing it as a parameter.

Changing code to use dependency injection only takes a few steps:

1. Move the dependency decision to a higher level component.
2. Pass the dependency as a parameter to the lower level component.
3. Remove any sub-dependencies from the lower level component.

Injecting dependencies is the simplest way to [invert
control](#dependency-inversion-principle).

### Uses

* Eliminates [shotgun surgery](#shotgun-surgery) from leaking sub-dependencies.
* Eliminates [divergent change](#divergent-change) by allowing runtime
  composition patterns, such as [decorators](#extract-decorator) and strategies.
* Makes it easier to avoid subclassing, following [composition over
  inheritance](#composition-over-inheritance).
* Extend existing classes without modifying them, following the [open/closed
  principle](#openclosed-principle).
* Avoids burdening classes with the knowledge of constructing their own
  dependencies, following the [single responsibility
  principle](#single-responsibility-principle).

### Example

In our example applications, users can view a summary of the answers to each
question on a survey. Users can select from one of several different summary
types to view. For example, they can see the most recent answer to each
question, or they can see a percentage breakdown of the answers to a multiple
choice question.

The controller passes in the name of the summarizer that the user selected:

` app/controllers/summaries_controller.rb@4e66ca3:2,11

`Survey#summaries_using` asks each of its questions for a summary using that
summarizer and the given options:

` app/models/survey.rb@4e66ca3:24

`Question#summary_using` instantiates the requested summarizer with the
requested options, then asks the summarizer to summarize the question:

` app/models/question.rb@4e66ca3:40,45

This is hard to follow and causes [shotgun surgery](#shotgun-surgery) because
the logic of building the summarizer is in `Question`, far away from the choice
of which summarizer to use, which is in `SummariesController`. Additionally, the
`options` parameter needs to be passed down several levels so that
summarizer-specific options can be provided when building the summarizer.

Let's remedy this by having the controller build the actual summarizer
instance. First, we'll move that logic from `Question` to `SummariesController`:

` app/controllers/summaries_controller.rb@5a9a4f1a:2,13

Then, we'll change `Question#summary_using` to take an instance instead of a
name:

` app/models/question.rb@5a9a4f1a:40,43

That `options` argument is no longer necessary because it was only used to
build the summarizer&mdash;which is now handled by the controller. Let's
remove it:

` app/models/question.rb@b8bbd4dd:40,43

We also don't need to pass it from `Survey`:

` app/models/survey.rb@b8bbd4dd:24

This interaction has already improved, because the `options` argument is no
longer uselessly passed around through two models. It's only used in the
controller where the summarizer instance is built. Building the summarizer in
the controller is appropriate, because the controller knows the name of the
summarizer we want to build, as well as which options are used when building it.

Now that we're using dependency injection, we can take this even further.

By default, in order to prevent the summary from influencing a user's own answers, users
don't see summaries for questions they haven't answered yet. Users
can click a link to override this decision and view the summary for every
question.

The information that determines whether or not to hide unanswered questions
lives in the controller:

` app/controllers/summaries_controller.rb@b8bbd4dd:19,25

However, this information is passed into `Survey#summaries_using`:

` app/controllers/summaries_controller.rb@b8bbd4dd:4

`Survey#summaries_using` decides whether to hide the answer to each question
based on that setting:

` app/models/survey.rb@b8bbd4dd:12,226

Again, the decision is far away from the dependent behavior.

We can combine our dependency injection with a [decorator](#extract-decorator)
to remove the duplicate decision:

` app/models/unanswered_question_hider.rb@256a9c92

We'll decide whether or not to decorate the base summarizer in our controller:

` app/controllers/summaries_controller.rb@256a9c92:9,15

Now, the decision of whether or not to hide answers is completely removed from
`Survey`:

` app/models/survey.rb@256a9c92:10,14

For more explanation of using decorators, as well as step-by-step instructions
for how to introduce them, see the [Extract
Decorator](#extract-decorator) chapter.

### Drawbacks

Injecting dependencies in our example made each class&mdash;`SummariesController`,
`Survey`, `Question` and `UnansweredQuestionHider`&mdash;easier to understand as a
unit. However, it's now difficult to understand what kind of summaries will be
produced just by looking at `Survey` or `Question`. You need to follow the stack
up to `SummariesController` to understand the dependencies and then look at
each class to understand how they're used.

In this case, we believe that using dependency injection resulted in an overall
win for readability and flexibility. However, it's important to remember that
the further you move a dependency's resolution from its use, the harder it is to
figure out what's actually being used in lower level components.

In our example, there isn't an easy way to know which class will be instantiated
for the `summarizer` parameter to `Question#summary_using`:

` app/models/question.rb@256a9c92:40,43

In our case, that will be one of `Summarizer::Breakdown`,
`Summarizer::MostRecent` or `Summarizer::UserAnswer`, or a
`UnansweredQuestionHider` that decorates one of the above. Developers will need
to trace back up through `Survey` to `SummariesController` to gather all the
possible implementations.

### Next Steps

* When pulling dependency resolution up into a higher level class, check that
  class to make sure it doesn't become a [large class](#large-class) because of
  all the logic surrounding dependency resolution.
* If a class is suffering from [divergent change](#divergent-change) because of
  new or modified dependencies, try moving dependency resolution further up the
  stack to a container class whose sole responsibility is managing dependencies.
* If methods contain [long parameter lists](#long-parameter-list), consider
  wrapping up several dependencies in a [parameter
  object](#introduce-parameter-object) or facade.
