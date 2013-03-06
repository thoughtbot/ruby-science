class Mailer < ActionMailer::Base
  default from: "from@example.com"

  def completion_notification(recipient)
    @recipient = recipient

    mail(
      to: recipient.email,
      subject: 'Thank you for completing the survey'
    )
  end

  def invitation_notification(invitation, body)
    mail(
      to: invitation.recipient_email,
      subject: 'You have been invited to take an online survey',
      body: body
    )
  end
end
