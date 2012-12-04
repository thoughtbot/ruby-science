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

  factory :option do
    text 'Hello'
  end

  factory :question, class: 'OpenQuestion' do
    survey
    sequence(:title) { |n| "Question #{n}" }

    factory :multiple_choice_question, class: 'MultipleChoiceQuestion' do
      ignore do
        options_texts { [] }
      end

      options do |attributes|
        attributes.options_texts.map do |text|
          FactoryGirl.build(:option, text: text, question_id: attributes.id)
        end
      end
    end

    factory :open_question, class: 'OpenQuestion' do
    end

    factory :scale_question, class: 'ScaleQuestion' do
    end
  end

  factory :survey do
    sequence(:title) { |n| "Survey #{n}" }
    author factory: :user
  end
end
