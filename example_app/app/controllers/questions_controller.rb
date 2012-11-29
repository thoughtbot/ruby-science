class QuestionsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    build_question
  end

  def create
    @survey = Survey.find(params[:survey_id])
    build_question
    if @question.save
      redirect_to @survey
    else
      render :new
    end
  end

  private

  def build_question
    type = params[:question][:type]
    @question = type.constantize.new(question_params)
    @question.survey = @survey
  end

  def question_params
    params.
      require(:question).
      permit(
        :title,
        :minimum,
        :maximum,
        options_attributes: [:text]
      )
  end
end
