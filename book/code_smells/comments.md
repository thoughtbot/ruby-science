## Comments

Comments can be used appropriately to introduce classes and provide
documentation. But used incorrectly, they mask readability and process problems
by further obfuscating already unreadable code.

### Symptoms

* Comments within method bodies.
* More than one comment per method.
* Comments that restate the method name in English.
* Todo comments.
* Commented out, dead code.

### Example

` app/models/open_question.rb@6f405a2:6,9

This comment is trying to explain what the following line of code does because
the code itself is too hard to understand. A better solution would be to improve
the legibility of the code.

Some comments add no value at all and can safely be removed:

``` ruby
class Invitation
  # Deliver the invitation
  def deliver
    Mailer.invitation_notification(self, message).deliver
  end
end
```

If there isn't a useful explanation to provide for a method or class beyond the
name, don't leave a comment.

### Solutions

* [Introduce explaining variable](#introduce-explaining-variable) to make
  obfuscated lines easier to read in pieces.
* [Extract method](#extract-method) to break up methods that are difficult
  to read.
* Move todo comments into a task management system.
* Delete commented out code and rely on version control in the event that you
  want to get it back.
* Delete superfluous comments that don't add more value than the method or class
  name.
