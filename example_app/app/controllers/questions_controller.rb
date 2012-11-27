class QuestionsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @question = @survey.questions.new
    @question.options = [Option.new, Option.new, Option.new]
    @submittable_type = params[:submittable_type_id]
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @submittable_type = params[:submittable_type_id]
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
    @question.submittable_type = @submittable_type
  end

  def question_params
    params.
      require(:question).
      permit(:submittable_type, :title, :options_attributes, :minimum, :maximum)
  end
end
