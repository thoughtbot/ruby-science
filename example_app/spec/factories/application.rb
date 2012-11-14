FactoryGirl.define do

  factory :question do
    title 'Question'
    submittable_type 'Open'

    factory :multiple_choice_question do
      submittable_type 'MultipleChoice'
    end

    factory :open_question do
      submittable_type 'Open'
    end

    factory :scale_question do
      submittable_type 'Scale'
    end
  end

  factory :survey do
    title 'Survey'
  end

end
