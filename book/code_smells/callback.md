## Callback

Callbacks are a convenient way to decorate the default `save` method with custom
persistence logic, without the drudgery of template methods, overriding, or
calling `super`.

However, callbacks are frequently abused by adding non-persistence logic to the
persistence life cycle, such as sending emails or processing payments. Models
riddled with callbacks are harder to refactor and prone to bugs, such as
accidentally sending emails or performing external changes before a database
transaction is committed.

### Symptoms

* Callbacks containing business logic, such as processing payments.
* Attributes that allow certain callbacks to be skipped.
* Methods such as `save_without_sending_email`, which skip callbacks.
* Callbacks that need to be invoked conditionally.

\clearpage

### Example

` app/models/survey_inviter.rb@fbd18280:27,37

` app/models/invitation.rb@fbd18280:9

` app/models/invitation.rb@fbd18280:20,22

In the above code, the `SurveyInviter` is simply creating `Invitation` records,
and the actual delivery of the invitation email is hidden behind
`Invitation.create!` via a callback.

If one of several invitations fails to save, the user will see a 500 page, but
some of the invitations will already have been saved and delivered. The user
will be unable to tell which invitations were sent.

Because delivery is coupled with persistence, there's no way to make sure that
all of the invitations are saved before starting to deliver emails.

### Solutions

* [Replace callback with method](#replace-callback-with-method) if the callback
  logic is unrelated to persistence.
