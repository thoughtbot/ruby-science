# Divergent Change

A class suffers from Divergent Change when it changes for multiple reasons.

### Symptoms

* You can't easily describe what the class does in one sentence.
* The class is changed more frequently than other classes in the application.
* Different changes to the class aren't related to each other.

\clearpage

### Example

` app/controllers/summaries_controller.rb@ec95b89f

This controller has multiple reasons to change:

* Control flow logic related to summaries, such as authentication.
* Any time a summarizer strategy is added or changed.

### Solutions

* [Extract Class](#extract-class) to move one cause of change to a new class.
* [Move Method](#move-method) if the class is changing because of methods that
  relate to another class.
* [Extract Validator](#extract-validator) to move validation logic out of
  models.
* [Introduce Form Object](#introduce-form-object) to move form logic out of
  controllers.
* [Use Convention over Configuration](#use-convention-over-configuration) to
  eliminate changes that can be inferred by a convention such as a name.

### Prevention

You can prevent Divergent Change from occurring by following the [Single
Responsibility Principle](#single-responsibility-principle). If a class has only
one responsibility, it has only one reason to change.

You can use churn to discover which files are changing most frequently. This
isn't a direct relationship, but frequently changed files often have more than
one responsibility, and thus more than one reason to change.
