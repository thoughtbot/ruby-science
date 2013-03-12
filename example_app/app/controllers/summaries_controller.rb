class SummariesController < ApplicationController
  def show
    @survey = Survey.find(params[:survey_id])
    @summaries = @survey.summaries_using(summarizer, options)
  end

  private

  def summarizer
    summarizer_name = params[:id]
    summarizer_factory = "Summarizer::#{summarizer_name.classify}".constantize
    summarizer_factory.new(options)
  end

  def options
    constraints.merge(user: current_user)
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
