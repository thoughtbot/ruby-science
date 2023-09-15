## Dependency Inversion Principle

The Dependency Inversion Principle, sometimes abbreviated as "DIP," was created
by Uncle Bob Martin.

The principle states:

> A. High-level modules should not depend on low-level modules. Both should
> depend on abstractions.
>
> B. Abstractions should not depend upon details. Details should depend upon
> abstractions.

This is a very technical way of proposing that developers invert control.

### Inversion of Control

Inversion of control is a technique for keeping software flexible. It combines
best with small classes with [single
responsibilities](#single-responsibility-principle). Inverting control means
assigning dependencies at run-time, rather than statically referencing
dependencies at each level.

This can be hard to understand as an abstract concept, but it's fairly simple in
practice. Let's jump into an example:

` app/models/survey.rb@77b22c5:10,15

` app/controllers/summaries_controller.rb@77b22c5:2,5

` app/controllers/summaries_controller.rb@77b22c5:17,23

The `summaries_using` method builds a summary of the answers to each of the
survey's questions.

However, we also want to hide the answers to questions that the user has not personally answered, so we [decorate](#extract-decorator) the `summarizer` with
an `UnansweredQuestionHider`. Note that we're statically referencing the
concrete, lower-level detail `UnansweredQuestionHider` from `Survey` rather than
depending on an abstraction.

In the current implementation, the `Survey#summaries_using` method will need to
change whenever something changes about the summaries. For example, hiding the
unanswered questions [requires changes to this
method](https://github.com/thoughtbot/ruby-science/commit/d60656aa).

Also, note that the conditional logic is spread across several layers.
`SummariesController` decides whether or not to hide unanswered questions. That
knowledge is passed into `Survey#summaries_using`. `SummariesController` also
passes the current user down into `Survey#summaries_using`, and from there it's
passed into `UnansweredQuestionHider`:

` app/models/unanswered_question_hider.rb@77b22c5

\clearpage

We can make future changes like this easier by inverting control:

` app/models/survey.rb@256a9c92:10,14

` app/controllers/summaries_controller.rb@256a9c92:2,15

Now the `Survey#summaries_using` method is completely ignorant of answer hiding;
it simply accepts a `summarizer` and the client (`SummariesController`) injects
a decorated dependency. This means that adding similar changes won't require
changing the `Summary` class at all.

This also allows us to simplify `UnansweredQuestionHider` by removing a
condition:

` app/models/unanswered_question_hider.rb@256a9c92:19,21

We no longer build `UnansweredQuestionHider` when a user isn't signed in, so we
don't need to check for a user.

### Where To Decide Dependencies

While following the previous example, you probably noticed that we didn't
eliminate the `UnansweredQuestionHider` dependency; we just moved it around.
This means that, while adding new summarizers or decorators won't affect
`Summary`, they will affect `SummariesController` in the current implementation.
So, did we actually make anything better?

In this case, the code was improved because the information that affects the
dependency decision&mdash;`params[:unanswered]`&mdash;is now closer to where we
make the decision. Before, we needed to pass a Boolean down into
`summaries_using`, causing that decision to leak across layers.

If you push your dependency decisions up until they reach the layer that contains the
information needed to make those decisions, you will prevent changes from
affecting several layers.

### Drawbacks

Following this principle results in more abstraction and indirection, as it's
often difficult to tell which class is being used for a dependency.

Looking at the example above, it's now impossible to know in `summaries_using`
which class will be used for the `summarizer`:

` app/models/survey.rb@256a9c92:10,14

This makes it difficult to know exactly what's going to happen. You can mitigate
this issue by using naming conventions and well-named classes. However, each
abstraction introduces more vocabulary into the application, making it more
difficult for new developers to learn the domain.

### Application

If you identify these smells in an application, you may want to adhere more
closely to the [dependency inversion principle](#dependency-inversion-principle) (DIP):

* Following DIP can eliminate [shotgun surgery](#shotgun-surgery) by
  consolidating dependency decisions.
* Code suffering from [divergent change](#divergent-change) may improve after
  having some of its dependencies injected.
* [Large classes](#large-class) and [long methods](#long-method) can be reduced
  by injecting dependencies, as this will outsource dependency resolution.

You may need to eliminate these smells in order to properly invert control:

* Excessive use of [callbacks](#callback) will make it harder to follow the DIP, because it's harder to inject dependencies into a callback.
* Using [mixins](#mixin) and [STI](#single-table-inheritance-sti) for reuse will
  make following the DIP more difficult, because inheritance is always
  decided statically. Because a class can't decide its parent class at run-time,
  inheritance can't follow inversion of control.

You can use these solutions to refactor towards DIP-compliance:

* [Inject dependencies](#inject-dependencies) to invert control.
* Use [extract class](#extract-class) to make smaller classes that are easier to
  compose and inject.
* Use [extract decorator](#extract-decorator) to make it possible to package a
  decision that involves multiple classes and inject it as a single dependency.
* [Replace callbacks with methods](#replace-callback-with-method) to make
  dependency injection easier.
* [Replace conditional with
  polymorphism](#replace-conditional-with-polymorphism) to make dependency
  injection easier.
* [Replace mixin with composition](#replace-mixin-with-composition) and [replace
  subclasses with strategies](#replace-subclasses-with-strategies) to make it
  possible to decide dependencies abstractly at run-time.
* [Use class as factory](#use-class-as-factory) to make it possible to
  abstractly instantiate dependencies without knowing which class is being used
  and without writing abstract factory classes.

Following the [single responsibility principle](#single-responsibility-principle)
and [composition over inheritance](#composition-over-inheritance) will make it
easier to follow the [dependency inversion principle](#dependency-inversion-principle). Following this principle will make it easier to
obey the [open/closed principle](#openclosed-principle).
