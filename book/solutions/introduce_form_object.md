# Introduce Form Object

A specialized type of [Extract Class](#extract-class) used to remove business
logic from controllers when processing data outside of an ActiveRecord model.

### Uses

* Keep business logic out of Controllers and Views.
* Add validation support to plain old Ruby objects.
* Display form validation errors using Rails conventions.
* Set the stage for [Extract Validator](#extract-validator).

### Example

The `create` action of our `InvitationsController` relies on user submitted data for
`message` and `recipients` (a comma delimited list of email addresses).

It performs a number of tasks:

* Finds the current survey.
* Validates the `message` is present.
* Validates each of the `recipients` are email addresses.
* Creates an invitation for each of the recipients.
* Sends an email to each of the recipients.
* Sets view data for validation failures.

` app/controllers/invitations_controller.rb@72c2a0d

By introducing a form object we can move the concerns of data validation, invitation
creation, and notifications to the new model `SurveyInviter`.

Including [ActiveModel::Model](https://github.com/rails/rails/blob/master/activemodel/lib/active_model/model.rb)
allows us to leverage the familiar
[Active Record Validation](http://guides.rubyonrails.org/active_record_validations_callbacks.html)
syntax.

\clearpage

As we introduce the form object we'll also extract an enumerable class `RecipientList`
and validators `EnumerableValidator` and `EmailValidator`. They will be covered 
in the chapters [Extract Class](#extract-class) and [Extract Validator](#extract-validator).

` app/models/survey_inviter.rb@7834dfd

Moving business logic into the new form object dramatically reduces the size and
complexity of the `InvitationsController`. The controller is now focused on the
interaction between the user and the models.

` app/controllers/invitations_controller.rb@fd6cd8d

### Next Steps

* Check that the controller no longer has [Long Methods](#long-method).
* Verify the new form object is not a [Large Class](#large-class).
* Check for places to re-use any new validators if [Extract Validator](#extract-validator)
was used during the refactoring.
