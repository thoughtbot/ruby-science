# Extract Validator

A form of [Extract Class](#extract-class) used to remove complex validation details
from `ActiveRecord` models. This technique also prevents duplication of validation
code across several files.

### Uses

* Keep validation implementation details out of models.
* Encapsulate validation details into a single file.
* Remove duplication among classes performing the same validation logic.

### Example

The `Invitation` class has validation details in-line. It checks that the
`repient_email` matches the formatting of the regular expression `EMAIL_REGEX`.

```ruby
# app/models/invitation.rb
class Invitation < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :recipient_email, presence: true, format: EMAIL_REGEX
end
```

We extract the validation details into a new class `EmailValidator`, and place the
new class into the `app/validators` directory.

` app/validators/email_validator.rb@7834dfd

Once the validator has been extracted. Rails has a convention for using the new
validation class. `EmailValidator` is used by setting `email: true` in the validation
arguments.

```ruby
# app/models/invitation.rb
class Invitation < ActiveRecord::Base
  validates :recipient_email, presence: true, email: true
end
```

The convention is to use the validation class name (in lowercase, and removing
`Validator` from the name). For exmaple, if we were validating an attribute with
`ZipCodeValidator` we'd set `zip_code: true` as an argument to the validation call.

When validating an array of data as we do in `SurveyInviter`, we use
the `EnumerableValidator` to loop over the contents of an array.

` app/models/survey_inviter.rb@21f7a57:10,13

\clearpage

The `EmailValidator` is passed in as an argument, and each element in the array
is validated against it.

` app/validators/enumerable_validator.rb@21f7a57

### Next Steps

* Verify the extracted validator does not have any [Long Methods](#long-methods).
* Check for other models that could use the validator.
