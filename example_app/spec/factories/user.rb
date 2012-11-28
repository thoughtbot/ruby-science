FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    first_name 'Ron'
    last_name 'Burgundy'
    email
    password 'password'
  end
end
