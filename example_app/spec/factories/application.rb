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
  end

  factory :open_submittable do
  end

  factory :option do
    text 'Hello'
  end

  factory :question, class: 'OpenQuestion' do
    survey
    sequence(:title) { |n| "Question #{n}" }

    factory :multiple_choice_question, class: 'MultipleChoiceQuestion' do
      transient do
        options_texts { [] }
      end

      options do |attributes|
        attributes.options_texts.map do |text|
          FactoryGirl.build(:option, text: text, question_id: attributes.id)
        end
      end

      submittable factory: :multiple_choice_submittable
    end

    factory :open_question, class: 'OpenQuestion' do
      submittable factory: :open_submittable
    end

    factory :scale_question, class: 'ScaleQuestion' do
      minimum 1
      maximum 2

      submittable factory: :scale_submittable
    end
  end

  factory :scale_submittable do
  end

  factory :survey do
    sequence(:title) { |n| "Survey #{n}" }
    author factory: :user
  end
end
