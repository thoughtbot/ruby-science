class User < ActiveRecord::Base
  include Clearance::User

  has_many(
    :received_messages,
    class_name: 'Message',
    foreign_key: 'recipient_id'
  )

  def answer_text_for(question)
    question.answers.for_user(self).text
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
