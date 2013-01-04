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
* Methods that use a parameter or local variable more than methods and instance
  variables of their own class.
* Methods that includes a class name in their own names (such as `invite_user`).
* Multiple private methods on the same class that accept the same parameter.
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
