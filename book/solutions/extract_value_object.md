# Extract Value Object

Value Objects are objects that represent a value (such as a dollar amount)
rather than a unique, identifiable entity (such as a particular user).

Value Objects often implement information derived from a primitive object, such
as the dollars and cents from a float, or the user name and domain from an email
string.

### Uses

* Remove [Duplicated Code](#duplicated-code) from making the same observations
  of primitive objects throughout the code base.
* Remove [Large Classes](#large-class) by splitting out query methods associated
  with a particular variable.
* Make the code easier to understand by fully-encapsulating related logic into a
  single class, following the [Single Responsibility
  Principle](#single-responsibility-principle).
* Eliminate [Divergent Change](#divergent-change) by extracting code related to
  an embedded semantic type.

### Example

`InvitationsController` is bloated with methods and logic relating to parsing a
string that contains a list of email addresses:

` app/controllers/invitations_controller.rb@72c2a0d6:46,52

We can [extract a new class](#extract-class) to offload this responsibility:

` app/models/recipient_list.rb@fd6cd8d5

``` ruby
# app/controllers/invitations_controller.rb
def recipient_list
  @recipient_list ||= RecipientList.new(params[:invitation][:recipients])
end
```

### Next Steps

* Search the application for [Duplicated Code](#duplicated-code) related to the
  newly extracted class.
* Value Objects should be Immutable. Make sure the extracted class doesn't have
  any writer methods.
