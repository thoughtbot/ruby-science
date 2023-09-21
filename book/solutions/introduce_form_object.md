## Introduce Form Object

This is a specialized type of [extract class](#extract-class) that is used to remove business
logic from controllers when processing data outside of an ActiveRecord model.

### Uses

* Keeps business logic out of controllers and views.
* Adds validation support to plain old Ruby objects.
* Displays form validation errors using Rails conventions.
* Sets the stage for [extract validator](#extract-validator).

### Example

The `create` action of our `InvitationsController` relies on user-submitted data for
`message` and `recipients` (a comma-delimited list of email addresses).

It performs a number of tasks:

* Finds the current survey.
* Validates that the `message` is present.
* Validates each of the `recipients`' email addresses.
* Creates an invitation for each of the recipients.
* Sends an email to each of the recipients.
* Sets view data for validation failures.

` app/controllers/invitations_controller.rb@72c2a0d

By introducing a form object, we can move the concerns of data validation,
invitation creation and notifications to the new model `SurveyInviter`.

Including [ActiveModel::Model](https://github.com/rails/rails/blob/main/activemodel/lib/active_model/model.rb)
allows us to leverage the familiar
[active record validation](http://guides.rubyonrails.org/active_record_validations_callbacks.html)
syntax.

\clearpage

As we introduce the form object, we'll also extract an enumerable class
`RecipientList` and validators `EnumerableValidator` and `EmailValidator`.
These will be covered in the [Extract Class](#extract-class) and
[Extract Validator](#extract-validator) chapters.

` app/models/survey_inviter.rb@7834dfd

Moving business logic into the new form object dramatically reduces the size and
complexity of the `InvitationsController`. The controller is now focused on the
interaction between the user and the models.

` app/controllers/invitations_controller.rb@fd6cd8d

### Next Steps

* Check that the controller no longer has [long methods](#long-method).
* Verify the new form object is not a [large class](#large-class).
* Check for places to re-use any new validators if [extract validator](#extract-validator)
was used during the refactoring.
