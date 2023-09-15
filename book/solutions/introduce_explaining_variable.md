## Introduce Explaining Variable

This refactoring allows you to break up a complex, hard-to-read statement by
placing part of it in a local variable. The only difficult part is finding a
good name for the variable.

### Uses

* Improves legibility of code.
* Makes it easier to [extract methods](#extract-method) by breaking up long
  statements.
* Removes the need for extra [comments](#comments).

### Example

This line of code was deemed hard enough to understand that adding a comment was necessary:

` app/models/open_question.rb@6f405a2:6,9

Adding an explaining variable makes the line easy to understand without requiring a
comment:

` app/models/open_question.rb@85bc5e6:6,9

You can follow up by using [replace temp with query](#replace-temp-with-query).

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
careful when doing this. The most obvious reason to extract a method is to reuse
the value of the variable.

However, there's another potential benefit: It changes the way developers read
the code. Developers instinctively read code from the top down. Expressions
based on variables place the details first, which means that developers will
start with the details:

``` ruby
text_from_ordered_answers = answers.order(:created_at).pluck(:text)
```

And work their way down to the overall goal of a method:

``` ruby
text_from_ordered_answers.join(', ')
```

Note that you naturally focus first on the code necessary to find the array of
texts and then progress to see what happens to those texts.

Once a method is extracted, the high-level concept comes first:

``` ruby
def summary
  text_from_ordered_answers.join(', ')
end
```

And then you progress to the details:

``` ruby
def text_from_ordered_answers
  answers.order(:created_at).pluck(:text)
end
```

You can use this technique of extracting methods to ensure that developers
focus on what's important first and only dive into the implementation details
when necessary.

### Next Steps

* [Replace temp with query](#replace-temp-with-query) if you want to reuse the
  expression or revert to the order in which a developer naturally reads the
  method.
* Check the affected expression to make sure that it's easy to read. If it's
  still too dense, try extracting more variables or methods.
* Check the extracted variable or method for [feature envy](#feature-envy).
