## Case Statement

Case statements are a sign that a method contains too much knowledge.

#### Symptoms

* Case statements that check the class of an object
* Case statements that check a type code
* [Divergent Change](#divergent-change) caused by changing and added `when`
  clauses
* [Shotgun Surgery](#shotgun-surgery) caused by changing multiple `case`
  statements

Case statements are extremely easy to find. Just grep your codebase for "case."

#### Example

Let's look at the `Question#summary` method:

` app/models/question.rb@a53319f:17,26

This method summarizes the answers to a question. The summary varies based on
the type of question.

#### Solutions

* If the `case` statement is checking a type code, such as `question_type`, use
  [Replace Typecode with Subclasses](#replace-typecode-with-subclasses).
* If the `case` statement is checking the class of an object, use [Replace
  Conditional with Polymorphism](#replace-conditional-with-polymorphism).
