## Rename Method

Renaming a method allows developers to improve the language of the domain as
their understanding naturally evolves during development.

The process is straightforward if there aren't too many references:

* Choose a new name for the method. This is the hard part!
* Change the method definition to the new name.
* Find and replace all references to the old name.

If there are a large number of references to the method you want to rename, you
can rename the callers one at a time while keeping everything in working order.
The process is mostly the same:

* Choose a new name for the method.
* Give the method its new name.
* Add an alias to keep the old name working.
* Find and replace all references to the old name.
* Remove the alias.

### Uses

* Eliminate [uncommunicative names](#uncommunicative-name).
* Change method names to conform to common interfaces.

### Example

In our example application, we generate summaries from answers to surveys. We
allow more than one type of summary, so strategies are employed to handle the
variations. There are a number of methods and dependencies that make this work.

`SummariesController#show` depends on `Survey#summarize`:

` app/controllers/summaries_controller.rb@c80381dc:4

`Survey#summarize` depends on `Question#summarize`:

` app/models/survey.rb@c80381dc:10,14

`Question#summarize` depends on `summarize` from its `summarizer` argument (a
strategy):

` app/models/question.rb@c80381dc:32,35

There are several summarizer classes, each of which respond to `summarize`.

This is confusing, largely because the word `summarize` is used to mean several
different things:

* `Survey#summarize` accepts a summarizer and returns an array of `Summary`
  instances.
* `Question#summarize` accepts a summarizer and returns a single `Summary`
  instance.
* `summarize` on summarizer strategies accepts a `Question` and returns a
  `String`.

Let's rename these methods so that each name is used uniquely and consistently
in terms of what it accepts, what it returns and what it does.

First, we'll rename `Survey#summarize` to reflect the fact that it returns a
collection.

` app/models/survey.rb@6a4169a5:10

Then we'll update the only reference to the old method:

` app/controllers/summaries_controller.rb@6a4169a5:4

Next, we'll rename `Question#summarize` to be consistent with the naming
introduced in `Survey`:

` app/models/question.rb@d97f7856:32

Finally, we'll update the only reference in `Survey#summaries_using`:

` app/models/survey.rb@d97f7856:12

We now have consistent and clearer naming:

* `summarize` means taking a question and returning a string value representing
  its answers.
* `summary_using` means taking a summarizer and using it to build a `Summary`.
* `summaries_using` means taking a set of questions and building a `Summary` for
  each one.

### Next Steps

* Check for explanatory comments that are no longer necessary now that the code
  is clearer.
* If the new name for a method is long, see if you can [extract
  methods](#extract-method) from it to make it smaller.
