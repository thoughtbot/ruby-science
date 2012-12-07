# Replace conditional with Null Object

Every Ruby developer is familiar with `nil`, and Ruby on Rails comes with a full
compliment of tools to handle it: `nil?`, `present?`, `try`, and more. However,
it's easy to let these tools hide duplication and leak concerns. If you find
yourself checking for `nil` all over your codebase, try replacing some of the
`nil` values with null objects.

### Uses

* Removes [Shotgun Surgery](#shotgun-surgery) when an existing method begins
  returning `nil`.
* Removes [Duplicated Code](#duplicated-code) related to checking for `nil`.
* Removes clutter, improving readability of code that consumes `nil`.

### Example

` app/models/question.rb@7a43dff:14,16

The `most_recent_answer_text` method asks its `answers` association for
`most_recent` answer. It only wants the `text` from that answer, but it must
first check to make sure that an answer actually exists to get `text` from. It
needs to perform this check because `most_recent` might return `nil`:

` app/models/answer.rb@7a43dff:15,17

This call clutters up the method, and returning `nil` is contagious: any method
that calls `most_recent` must also check for `nil`. The concept of a missing
answer is likely to come up more than once, as in this example:

` app/models/user.rb@7a43dff:4,6

Again, `most_recent_answer_text` might return `nil`:

` app/models/answer.rb@7a43dff:11,13

The `User#answer_text_for` method duplicates the check for a missing answer, and
worse, it's repeating the logic of what happens when you need text without an
answer.

We can remove these checks entirely from `Question` and `User` by introducing a
Null Object:

` app/models/question.rb@8698fd4:14,16

` app/models/user.rb@8698fd4:4,6

\clearpage

We're now just assuming that `Answer` class methods will return something
answer-like; specifically, we expect an object that returns useful `text`. We
can refactor `Answer` to handle the `nil` check:

` app/models/answer.rb@8698fd4

Note that `for_user` and `most_recent` return a `NullAnswer` if no answer can be
found, so these methods will never return `nil`. The implementation for
`NullAnswer` is simple:

` app/models/null_answer.rb@8698fd4

\clearpage

We can take things just a little further and remove a bit of duplication with a
quick [Extract Method](#extract-method):

` app/models/answer.rb@1e35c68

Now we can easily create `Answer` class methods that return a usable answer, no
matter what.

### Drawbacks

Introducing a null object can remove duplication and clutter, but it can also
cause pain and confusion:

* As a developer reading a method like `Question#most_recent_answer_text`, you
  may be confused to find that `most_recent_answer` returned an instance of
  `NullAnswer` and not `Answer`.
* Whenever a method needs to worry about whether or not an actual answer exists,
  you'll need to add explicit `present?` checks and define `present?` to return
  `false` on your null object. This is common in views, when the view needs to
  add special markup to denote missing values.
* `NullAnswer` may eventually need to reimplement large part of the `Answer`
  API, leading to potential [Duplicated Code](#duplicated-code) and [Shotgun
  Surgery](#shotgun-surgery), which is largely what we hoped to solve in the
  first place.

Don't introduce a null object until you find yourself swatting enough `nil`
values to be annoying, and make sure you're actually cutting down on conditional
logic when you introduce it.

### Next Steps

* Look for other `nil` checks from the return values of refactored methods.
* Make sure your Null Object class implements the required methods from the
  original class.
* Make sure no [Duplicated Code](#duplicated-code) exists between the Null
  Object class and the original.

## truthiness, try, and other tricks

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

