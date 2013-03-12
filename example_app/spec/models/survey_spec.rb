require 'spec_helper'

describe Survey do
  it { should validate_presence_of(:title) }
  it { should belong_to(:author).class_name('User') }
  it { should have_many(:completions) }
  it { should have_many(:questions) }
end

describe Survey, '#summaries_using' do
  it 'applies the given summarizer to each question' do
    questions = [stub_question, stub_question]
    survey = build_stubbed(:survey, questions: questions)
    summarizer = 'open'
    options = { key: :value }

    result = survey.summaries_using(summarizer, options)

    should_summarize_questions questions, summarizer, options
    result.map(&:value).should == %w(result result)
  end

  it 'applies the given summarizer to each question answered by the user' do
    user = build_stubbed(:user)
    answered_question = stub_question(user: user, answered: true)
    unanswered_question = stub_question(user: user, answered: false)
    questions = [answered_question, unanswered_question]
    questions.stubs(:answered_by).with(user).returns(questions)
    survey = build_stubbed(:survey, questions: questions)
    options = { answered_by: user }
    summarizer = 'open'

    result = survey.summaries_using(summarizer, options)

    should_summarize_questions [answered_question], summarizer, options
    result.last.title.should == unanswered_question.title
    result.map(&:value).
      should eq ['result', "You haven't answered this question"]
  end

  def stub_question(arguments = {})
    build_stubbed(:question).tap do |question|
      question.stubs(:summary_using).returns(Summary.new('title', 'result'))
      question.
        stubs(:answered_by?).
        with(arguments[:user]).
        returns(arguments[:answered])
    end
  end

  def should_summarize_questions(questions, summarizer, options)
    questions.each do |question|
      question.should have_received(:summary_using).with(summarizer, options)
    end
  end
end
