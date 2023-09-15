## Replace Callback with Method

If your models are hard to use and change because their persistence logic is
coupled with business logic, one way to loosen things up is by replacing
[callbacks](#callback).

### Uses

* Reduces coupling of persistence logic with business logic.
* Makes it easier to extract concerns from models.
* Fixes bugs from accidentally triggered callbacks.
* Fixes bugs from callbacks with side effects when transactions roll back.

### Steps

* Use [extract method](#extract-method) if the callback is an anonymous block.
* Promote the callback method to a public method if it's private.
* Call the public method explicitly, rather than relying on `save` and callbacks.

\clearpage

### Example

` app/models/survey_inviter.rb@fbd18280:27,37

` app/models/invitation.rb@fbd18280:9

` app/models/invitation.rb@fbd18280:18,22

In the above code, the `SurveyInviter` is simply creating `Invitation` records,
and the actual delivery of the invitation email is hidden behind
`Invitation.create!` via a callback.

If one of several invitations fails to save, the user will see a 500 page, but
some of the invitations will already have been saved and delivered. The user
will be unable to tell which invitations were sent.

Because delivery is coupled with persistence, there's no way to make sure that
all the invitations are saved before starting to deliver emails.

Let's make the callback method public so that it can be called from
`SurveyInviter`:

` app/models/invitation.rb@db6cad48:17,21

Then remove the `after_create` line to detach the method from persistence.

Now we can split invitations into separate persistence and delivery phases:

` app/models/survey_inviter.rb@db6cad48:27,43

If any of the invitations fail to save, the transaction will roll back. Nothing
will be committed and no messages will be delivered.

### Next Steps

* Find other instances where the model is saved, to make sure that the extracted
  method doesn't need to be called.
