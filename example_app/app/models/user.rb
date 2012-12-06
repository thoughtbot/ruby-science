class User < ActiveRecord::Base
  include Clearance::User

  def answer_text_for(question)
    question.answers.joins(:completion).where(completions: { user_id: id }).last.text
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
