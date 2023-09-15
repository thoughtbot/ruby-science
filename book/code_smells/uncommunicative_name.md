## Uncommunicative Name

Software is run by computers&mdash;but written and read by humans. Names provide
important information to developers who are trying to understand a piece of
code. Patterns and challenges when naming a method or class can also provide
clues for refactoring.

### Symptoms

* Difficulty understanding a method or class.
* Methods or classes with similar names but dissimilar functionality.
* Redundant names, such as names that include the type of object to which they
  refer.

### Example

In our example application, the `SummariesController` generates summaries from a
`Survey`:

` app/controllers/summaries_controller.rb@ac47150:4

The `summarize` method on `Survey` asks each `Question` to `summarize` itself
using a `summarizer`:

` app/models/survey.rb@ac47150:10,14

The `summarize` method on `Question` gets a value by calling `summarize` on a
summarizer, and then builds a `Summary` using that value.

` app/models/question.rb@6a4169a5:32,35

There are several summarizer classes, each of which respond to `summarize`.

If you're lost, don't worry: You're not the only one. The confusing maze of
similar names makes this example extremely hard to follow.

See [rename method](#rename-method) to see how we improve the situation.

### Solutions

* [Rename method](#rename-method) if a well-factored method isn't well named.
* [Extract class](#extract-class) if a class is doing too much to have a
  meaningful name.
* [Extract method](#extract-method) if a method is doing too much to have a
  meaningful name.
* [Inline class](#inline-class) if a class is too abstract to have a meaningful
  name.
