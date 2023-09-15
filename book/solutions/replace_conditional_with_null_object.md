## Replace Conditional with Null Object

Every Ruby developer is familiar with `nil`, and Ruby on Rails comes with a full
complement of tools to handle it: `nil?`, `present?`, `try` and more. However,
it's easy to let these tools hide duplication and leak concerns. If you find
yourself checking for `nil` all over your codebase, try replacing some of the
`nil` values with Null Objects.

### Uses

* Removes [shotgun surgery](#shotgun-surgery) when an existing method begins
  returning `nil`.
* Removes [duplicated code](#duplicated-code) related to checking for `nil`.
* Removes clutter, improving readability of code that consumes `nil`.
* Makes logic related to presence and absence easier to reuse, making it easier
  to [avoid duplication](#dry).
* Replaces conditional logic with simple commands, following [tell, don't
  ask](#tell-dont-ask).

### Example

` app/models/question.rb@7a43dff:14,16

The `most_recent_answer_text` method asks its `answers` association for
`most_recent` answer. It only wants the `text` from that answer, but it must
first check to make sure that an answer actually exists to get `text` from. It
needs to perform this check because `most_recent` might return `nil`:

` app/models/answer.rb@7a43dff:15,17

This call clutters up the method, and returning `nil` is contagious: Any method
that calls `most_recent` must also check for `nil`. The concept of a missing
answer is likely to come up more than once, as in this example:

` app/models/user.rb@7a43dff:4,6

Again, `for_user` might return `nil`:

` app/models/answer.rb@7a43dff:11,13

The `User#answer_text_for` method duplicates the check for a missing
answer&mdash;and worse, it's repeating the logic of what happens when you need
text without an answer.

We can remove these checks entirely from `Question` and `User` by introducing a
null object:

` app/models/question.rb@8698fd4:14,16

` app/models/user.rb@8698fd4:4,6

We're now just assuming that `Answer` class methods will return something
answer-like; specifically, we expect an object that returns useful `text`. We
can refactor `Answer` to handle the `nil` check:

` app/models/answer.rb@8698fd4

Note that `for_user` and `most_recent` return a `NullAnswer` if no answer can be
found, so these methods will never return `nil`. The implementation for
`NullAnswer` is simple:

` app/models/null_answer.rb@8698fd4

We can take things just a little further and remove a bit of duplication with a
quick [extract method](#extract-method):

` app/models/answer.rb@1e35c68

Now we can easily create `Answer` class methods that return a usable answer, no
matter what.

### Drawbacks

Introducing a null object can remove duplication and clutter. But it can also
cause pain and confusion:

* As a developer reading a method like `Question#most_recent_answer_text`, you
  may be confused to find that `most_recent_answer` returned an instance of
  `NullAnswer` and not `Answer`.
* It's possible some methods will need to distinguish between `NullAnswer`s and
  real `Answer`s. This is common in views, when special markup is required to
  denote missing values. In this case, you'll need to add explicit `present?`
  checks and define `present?` to return `false` on your null object.
* `NullAnswer` may eventually need to reimplement large part of the `Answer`
  API, leading to potential [duplicated code](#duplicated-code) and [shotgun
  surgery](#shotgun-surgery), which is largely what we hoped to solve in the
  first place.

Don't introduce a null object until you find yourself swatting enough `nil`
values to grow annoyed. And make sure the removal of the `nil`-handling logic
outweighs the drawbacks above.

### Next Steps

* Look for other `nil` checks of the return values of refactored methods.
* Make sure your null object class implements the required methods from the
  original class.
* Make sure no [duplicated code](#duplicated-code) exists between the null
  object class and the original.

\clearpage

### Truthiness, `try` and Other Tricks

All checks for `nil` are a condition, but Ruby provides many ways to check for
`nil` without using an explicit `if`. Watch out for `nil` conditional checks
disguised behind other syntax. The following are all roughly equivalent:

```` ruby
# Explicit if with nil?
if user.nil?
  nil
else
  user.name
end

# Implicit nil check through truthy conditional
if user
  user.name
end

# Relies on nil being falsey
user && user.name

# Call to try
user.try(:name)
````

