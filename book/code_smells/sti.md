## Single Table Inheritance (STI)

Using subclasses is a common method of achieving reuse in object-oriented
software. Rails provides a mechanism for storing instances of different classes
in the same table, called Single Table Inheritance. Rails takes care of most
of the details by writing the class's name to the type column and instantiating
the correct class when results come back from the database.

Inheritance has its own pitfalls (see [composition over
inheritance](#composition-over-inheritance)) and STI introduces a few new
gotchas that may compel you to consider an alternate solution.

### Symptoms

* You need to change from one subclass to another.
* Behavior is shared among some subclasses but not others.
* One subclass is a fusion of one or more other subclasses.

\clearpage

### Example

This method on `Question` changes the question to a new type. Any necessary
attributes for the new subclass are provided to the `attributes` method.

` app/models/question.rb@8c929881:23,37

This transition is difficult for a number of reasons:

* You need to worry about common `Question` validations.
* You need to make sure validations for the old subclass are not used.
* You need to make sure validations for the new subclass are used.
* You need to delete data from the old subclass, including associations.
* You need to support data from the new subclass.
* Common attributes need to remain the same.

The implementation achieves all these requirements, but is awkward:

* You can't actually change the class of an instance in Ruby, so you need to
  return the instance of the new class.
* The implementation requires deleting and creating records, but part of the
  transaction (`destroy`) must execute before you can validate the new instance.
  This results in control flow using exceptions.
* The STI abstraction leaks into the model, because it needs to understand that
  it has a `type` column. STI models normally don't need to understand that
  they're implemented using STI.
* It's hard to understand why this method is implemented the way it is, so other
  developers fixing bugs or refactoring in the future will have a hard time
  navigating it.

### Solutions

* If you're using STI to reuse common behavior, use [replace subclasses with
  strategies](#replace-subclasses-with-strategies) to switch to a
  composition-based model.
* If you're using STI so that you can easily refer to several different classes
  in the same table, switch to using a polymorphic association instead.

### Prevention

By following [composition over inheritance](#composition-over-inheritance),
you'll use STI as a solution less often.
