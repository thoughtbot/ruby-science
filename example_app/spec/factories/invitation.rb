FactoryGirl.define do
  factory :invitation do
    sender
    recipient_email { generate(:email) }
  end
end
