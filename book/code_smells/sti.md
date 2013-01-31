# Single Table Inheritance

Using subclasses is a common method of achieving reuse in object-oriented
software. Rails provides a mechanism for storing instances of different classes
in the same table, called Single Table Inheritance. Rails will take care of most
of the details, writing the class's name to the type column and instantiating
the correct class when results come back from the database.

Inheritance has its own pitfalls - see [Composition Over
Inheritance](#composition-over-inheritance) - and STI introduces a few new
gotchas that may cause you to consider an alternate solution.

### Symptoms

* You need to change from one subclass to another.
* You find a situation where an instance shares behavior of multiple subclasses.

### Example

### Solutions

### Prevention
