class SummariesController < ApplicationController
  def show
    @survey = Survey.find(params[:survey_id])
    @summaries = @survey.summaries_using(summarizer, constraints)
  end

  private

  def summarizer
    summarizer_class.new(user: current_user)
  end

  def summarizer_class
    "Summarizer::#{params[:id].classify}".constantize
  end

  def constraints
    if include_unanswered?
      {}
    else
      { answered_by: current_user }
    end
  end

  def include_unanswered?
    params[:unanswered]
  end
end
