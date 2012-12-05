## Case Statement

Case statements are a sign that a method contains too much knowledge.

#### Symptoms

* Case statements that check the class of an object.
* Case statements that check a type code.
* [Divergent Change](#divergent-change) caused by changing and added `when`
  clauses.
* [Shotgun Surgery](#shotgun-surgery) caused by changing multiple `case`
  statements.

Actual `case` statements are extremely easy to find. Just grep your codebase for
"case." However, you should also be on the lookout for `case`'s sinister cousin,
the repetitive `if-elsif`.

### Type Codes

Some applications contain type codes: fields that store type information about
objects. These fields are easy to add and seem innocent, but they result in code
that's harder to maintain. A better solution is to take advantage of Ruby's
ability to invoke different behavior based on an object's class, called "dynamic
dispatch." Using a case statement with a type code inelegantly reproduces
dynamic dispatch.

Note that the special `type` column that ActiveRecord uses is not necessarily a
type code.  The `type` column is used to serialize an object's class to the
database, so that the correct class can be instantiated later on. Unless you're
inflecting on the `type` column in `case` or `if` statements, this is not a
smell.

#### Example

Let's look at the `Question#summary` method:

` app/models/question.rb@a53319f:17,26

This method summarizes the answers to a question. The summary varies based on
the type of question.

#### Solutions

* If the `case` statement is checking a type code, such as `question_type`, use
  [Replace Typecode with Subclasses](#replace-type-code-with-subclasses).
* If the `case` statement is checking the class of an object, use [Replace
  Conditional with Polymorphism](#replace-conditional-with-polymorphism).
