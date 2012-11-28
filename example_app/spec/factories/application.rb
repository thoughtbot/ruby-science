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

  factory :question do
    survey
    title 'Question'
    question_type 'OpenQuestion'

    factory :multiple_choice_question do
      ignore do
        options_texts { [] }
      end

      options do |attributes|
        attributes.options_texts.map do |text|
          FactoryGirl.build(:option, text: text, question_id: attributes.id)
        end
      end

      question_type 'MultipleChoiceQuestion'
    end

    factory :open_question do
      question_type 'OpenQuestion'
    end

    factory :scale_question do
      question_type 'ScaleQuestion'
    end
  end

  factory :survey do
    title 'Survey'
    author factory: :user
  end

end
