require 'spec_helper'

describe Completion, 'associations' do
  it { should belong_to(:survey) }
  it { should belong_to(:user) }
  it { should have_many(:answers) }
end

describe Completion, '#answers_attributes=' do
  it 'builds answers to each of the questions' do
    completion = build_stubbed(:completion)

    completion.answers_attributes = {
      1 => { text: 'one' },
      2 => { text: 'two' },
      3 => { text: 'three' }
    }

    answer_attributes =
      completion.
      answers.
      map { |answer| answer.attributes.slice('completion_id', 'question_id', 'text') }
    answer_attributes.should == [
      { 'completion_id' => completion.id, 'question_id' => 1, 'text' => 'one' },
      { 'completion_id' => completion.id, 'question_id' => 2, 'text' => 'two' },
      { 'completion_id' => completion.id, 'question_id' => 3, 'text' => 'three' }
    ]
  end
end

describe Completion, '#breakdown' do
  it 'returns results from the breakdown summarizer' do
    survey = build_stubbed(:survey)
    completion = build_stubbed(:completion, survey: survey)
    summaries = [stub('summary'), stub('summary')]
    summarizer = stub('summarizer')
    Summarizer::Breakdown.stubs(:new).with({}).returns(summarizer)
    survey.stubs(summaries_using: summaries)

    result = completion.breakdown

    survey.should have_received(:summaries_using).with(summarizer)
    result.should == summaries
  end
end

describe Completion, '#save' do
  it 'delivers a completion notification' do
    Mailer.stubs(completion_notification: stub(deliver: true))
    user = create(:user)
    completion = create(:completion, user: user)

    Mailer.should have_received(:completion_notification).with(user)
  end
end

describe Completion, '#score' do
  it 'adds up scores from the answers' do
    survey = create(:survey)
    completion = create(:completion, survey: survey)
    scores = [1, 2, 3]
    scores.each do |score|
      submittable = create(:scale_submittable, minimum: 1, maximum: 3)
      question = create(
        :scale_question,
        survey: survey,
        submittable: submittable
      )
      create(:answer, completion: completion, question: question, text: score)
    end

    result = completion.score

    result.should eq 6
  end
end
