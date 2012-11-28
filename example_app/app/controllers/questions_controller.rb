class QuestionsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @question = @survey.questions.new
    @question.options = [Option.new, Option.new, Option.new]
    @question.type = params[:type]
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
    @question = @survey.questions.new(question_params)
  end

  def question_params
    params.
      require(:question).
      permit(
        :type,
        :title,
        :minimum,
        :maximum,
        options_attributes: [:text]
      )
  end
end
