FactoryGirl.define do
  factory :answer do
    completion
    question
    text 'Hello'
  end

  factory :completion do
    survey
    user
  end

  factory :multiple_choice_submittable do
    ignore do
      options_texts { [] }
    end

    options do |attributes|
      attributes.options_texts.map do |text|
        FactoryGirl.build(:option, text: text, question_id: attributes.id)
      end
    end
  end

  factory :open_submittable do
  end

  factory :option do
    text 'Hello'
  end

  factory :question do
    sequence(:title) { |n| "Question #{n}" }
    submittable factory: :open_submittable
    survey

    factory :multiple_choice_question do
      submittable factory: :multiple_choice_submittable
    end

    factory :open_question do
      submittable factory: :open_submittable
    end

    factory :scale_question do
      submittable factory: :scale_submittable
    end
  end

  factory :scale_submittable do
    minimum 1
    maximum 2
  end

  factory :survey do
    sequence(:title) { |n| "Survey #{n}" }
    author factory: :user
  end

  factory :unsubscribe do
    email
  end
end
