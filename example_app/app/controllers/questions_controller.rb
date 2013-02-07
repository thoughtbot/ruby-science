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

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    @question.update_attributes(question_params)
    if @question.save
      redirect_to @question.survey
    else
      render :edit
    end
  end

  private

  def build_question
    @question = type.constantize.new(question_params)
    @question.build_submittable(submittable_params)
    @question.survey = @survey
  end

  def type
    params[:question][:type]
  end

  def question_params
    params.
      require(:question).
      permit(:title, options_attributes: [:text])
  end

  def submittable_params
    if submittable_attributes = params[:question][:submittable_attributes]
      submittable_attributes.permit(:minimum, :maximum)
    else
      {}
    end
  end
end
