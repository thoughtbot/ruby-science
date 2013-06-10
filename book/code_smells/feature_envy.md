# Feature Envy

Feature envy reveals a method (or method-to-be) that would work better on a
different class.

Methods suffering from feature envy contain logic that is difficult to reuse,
because the logic is trapped within a method on the wrong class. These methods
are also often private methods, which makes them unavailable to other classes.
Moving the method (or affected portion of a method) to a more appropriate class
improves readability, makes the logic easier to reuse, and reduces coupling.

### Symptoms

* Repeated references to the same object.
* Parameters or local variables which are used more than methods and instance
  variables of the class in question.
* Methods that includes a class name in their own names (such as `invite_user`).
* Private methods on the same class that accept the same parameter.
* [Law of Demeter](#law-of-demeter) violations.
* [Tell, Don't Ask](#tell-dont-ask) violations.

### Example

` app/models/completion.rb@e6895ad:16,21

The `answer` local variable is used twice in the block: once to get its
`question`, and once to get its `text`. This tells us that we can probably
extract a new method and move it to the `Answer` class.

### Solutions

* [Extract Method](#extract-method) if only part of the method suffers from
  feature envy, and then move the method.
* [Move Method](#move-method) if the entire method suffers from feature envy.
* [Inline Classes](#inline-class) if the envied class isn't pulling its weight.

### Prevention

Following the [Law of Demeter](#law-of-demeter) will prevent a lot of Feature
Envy by limiting the dependencies of each method.

Following [Tell, Don't Ask](#tell-dont-ask) will prevent Feature Envy by
avoiding unnecessary inspection of another object's state.
