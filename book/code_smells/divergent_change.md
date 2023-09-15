## Divergent Change

A class suffers from Divergent Change when it changes for multiple reasons.

### Symptoms

* You can't easily describe what the class does in one sentence.
* The class is changed more frequently than other classes in the application.
* Different changes to the class aren't related to each other.

\clearpage

### Example

` app/controllers/summaries_controller.rb@ec95b89f

This controller has many reasons to change:

* Control flow logic related to summaries, such as authentication.
* Any instance in which a summarizer strategy is added or changed.

### Solutions

* [Extract class](#extract-class) to move one cause of change to a new class.
* [Move method](#move-method) if the class is changing because of methods that
  relate to another class.
* [Extract validator](#extract-validator) to move validation logic out of
  models.
* [Introduce form object](#introduce-form-object) to move form logic out of
  controllers.
* [Use convention over configuration](#use-convention-over-configuration) to
  eliminate changes that can be inferred by a convention, such as a name.

### Prevention

You can prevent divergent change from occurring by following the [single
responsibility principle](#single-responsibility-principle). If a class has only
one responsibility, it has only one reason to change.

Following the [open/closed principle](#openclosed-principle) limits future
changes to classes, including divergent change.

Following [composition over inheritance](#composition-over-inheritance) will
make it easier to create small classes, preventing divergent change.

If a large portion of the class is devoted to instantiating subclasses, try
following the [dependency inversion principle](#dependency-inversion-principle).

You can use churn to discover which files are changing most frequently. This
isn't a direct relationship, but frequently changed files often have more than
one responsibility and thus more than one reason to change.
