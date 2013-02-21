class SummariesController < ApplicationController
  def show
    @survey = Survey.find(params[:survey_id])
    @summaries = @survey.summaries_using(summarizer)
  end

  private

  def summarizer
    summarizer_class.new(user: current_user)
  end

  def summarizer_class
    "Summarizer::#{params[:id].classify}".constantize
  end
end
