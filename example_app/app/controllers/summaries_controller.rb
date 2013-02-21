class SummariesController < ApplicationController
  def show
    @survey = Survey.find(params[:survey_id])
    @summaries = @survey.summaries_using(decorated_summarizer)
  end

  private

  def decorated_summarizer
    if include_unanswered?
      summarizer
    else
      UnansweredQuestionHider.new(summarizer, current_user)
    end
  end

  def summarizer
    summarizer_class.new(user: current_user)
  end

  def summarizer_class
    "Summarizer::#{params[:id].classify}".constantize
  end

  def include_unanswered?
    params[:unanswered]
  end
end
