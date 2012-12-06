class User < ActiveRecord::Base
  include Clearance::User

  def answer_text_for(question)
    question.answers.for_user(self).try(:text) || Answer::MISSING_TEXT
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
