class Mailer < ActionMailer::Base
  default from: "from@example.com"

  def completion_notification(recipient)
    @recipient = recipient

    mail(
      to: recipient.email,
      subject: 'Thank you for completing the survey'
    )
  end
end
