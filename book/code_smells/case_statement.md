
## Case Statement

Case Statements are a sign that a method contains too much knowledge.

### Symptoms

* Case statements that check the class of an object.
* Case statements that check a type code.
* [Divergent change](#divergent-change) caused by changing or adding `when`
  clauses.
* [Shotgun surgery](#shotgun-surgery) caused by duplicating the case statement.

Actual `case` statements are extremely easy to find. Just grep your codebase for
"case." However, you should also be on the lookout for `case`'s sinister cousin,
the repetitive `if-elsif`.

#### Type Codes

Some applications contain type codes&mdash;fields that store type information about
objects. These fields are easy to add and seem innocent, but result in code
that's harder to maintain. A better solution is to take advantage of Ruby's
ability to invoke different behavior based on an object's class, called "dynamic
dispatch." Using a case statement with a type code inelegantly reproduces
dynamic dispatch.

The special `type` column that ActiveRecord uses is not necessarily a type code.
The `type` column is used to serialize an object's class to the database so
that the correct class can be instantiated later on. If you're just using the
`type` column to let ActiveRecord decide which class to instantiate, this isn't
a smell. However, make sure to avoid referencing the `type` column from `case`
or `if` statements.

### Example

This method summarizes the answers to a question. The summary varies based on
the type of question.

` app/models/question.rb@a53319f:17,26

\clearpage

Note that many applications replicate the same `case` statement, which is a more
serious offense. This view duplicates the `case` logic from `Question#summary`,
this time in the form of multiple `if` statements:

` app/views/questions/_question.html.erb@a53319f:5,25

### Solutions

* [Replace type code with subclasses](#replace-type-code-with-subclasses) if the
  `case` statement is checking a type code, such as `question_type`.
* [Replace conditional with polymorphism](#replace-conditional-with-polymorphism)
  when the `case` statement is checking the class of an object.
* [Use convention over configuration](#use-convention-over-configuration) when
  selecting a strategy based on a string name.
