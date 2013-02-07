class TypesController < ApplicationController
  def new
    @question = Question.find(params[:question_id])
    assign_type
    @new_question = type.constantize.new
    @new_question.build_submittable({})
  end

  def create
    @question = Question.find(params[:question_id])
    @new_question = @question.switch_to(
      type,
      question_params,
      submittable_attributes
    )

    if @new_question.errors.empty?
      redirect_to @question.survey
    else
      assign_type
      render 'new'
    end
  end

  private

  def assign_type
    @new_type = type.underscore
  end

  def question_params
    params[:question].except(:submittable_attributes)
  end

  def submittable_attributes
    params[:question][:submittable_attributes] || {}
  end

  def type
    params[:question][:type]
  end
end
