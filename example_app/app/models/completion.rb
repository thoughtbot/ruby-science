class Completion < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :survey
  belongs_to :user
  has_many :answers

  after_create :completion_notification

  def answers_attributes=(answers_attributes)
    answers_attributes.each do |answer_attributes|
      answers.build(answer_attributes)
    end
  end

  private

  def completion_notification
    Mailer.completion_notification(user.first_name, user.last_name, user.email).deliver
  end
end
