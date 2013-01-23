class SummariesController < ApplicationController
  def show
    @survey = Survey.find(params[:survey_id])
    @summaries = @survey.summarize(summarizer)
  end

  private

  def summarizer
    summarizer_class.new(user: current_user)
  end

  def summarizer_class
    case params[:id]
    when 'breakdown'
      Breakdown
    when 'most_recent'
      MostRecent
    when 'user_answer'
      UserAnswer
    else
      raise "Unknown summary type: #{params[:id]}"
    end
  end
end
