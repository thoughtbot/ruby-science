class SummariesController < ApplicationController
  def show
    @survey = Survey.find(params[:survey_id])
    @summaries = @survey.summarize(summarizer)
  end

  private

  def summarizer
    case params[:id]
    when 'breakdown'
      Breakdown.new(user: current_user)
    when 'most_recent'
      MostRecent.new(user: current_user)
    when 'user_answer'
      UserAnswer.new(user: current_user)
    else
      raise "Unknown summary type: #{params[:id]}"
    end
  end
end
