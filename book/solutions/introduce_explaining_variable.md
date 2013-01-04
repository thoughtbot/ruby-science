# Introduce Explaining Variable

This refactoring allows you to break up a complex, hard-to-read statement by
placing part of it in a local variable. The only difficult part is finding a
good name for the variable.

### Uses

* Improves legibility of code.
* Makes it easier to [Extract Methods](#extract-method) by breaking up long
  statements.
* Removes the need for extra [Comments](#comments).

### Example

This line of code was hard enough to understand that a comment was added:

` app/models/open_question.rb@6f405a2:6,9

Adding an explaining variable makes the line easy to understand without a
comment:

` app/models/open_question.rb@85bc5e6:6,9

You can follow up by using [Replace Temp with Query](#replace-temp-with-query).

``` ruby
def summary
  text_from_ordered_answers.join(', ')
end

private

def text_from_ordered_answers
  answers.order(:created_at).pluck(:text)
end
```

This increases the overall size of the class and moves
`text_from_ordered_answers` further away from `summary`, so you'll want to be
careful when doing this.

However, it can be worth it. If you need to reuse the value in the variable,
you'll need to extract a method. Further, methods can improve the readability.
Expressions based on variables need to be read top-down, with the details first.
Note that, with the variable, you naturally focus first on the code necessary to
find the array of texts, and then progress to see what happens to those texts.
Once a method is extracted, you naturally focus first on the high level concept
("this will join text from ordered answers with a comma") and then progress to
the details if necessary ("how do I find these ordered texts?").

### Next Steps

* [Replace Temp with Query](#replace-temp-with-query) if you want to reuse the
  expression or revert the naturally order in which a developer reads the
  method.
* Check the affected expression to make sure that it's easy to read. If it's
  still too dense, try extracting more variables or methods.
* Check the extracted variable or method for [Feature Envy](#feature-envy).
