class TypesController < ApplicationController
  def new
    @question = Question.find(params[:question_id])
    @question.build_submittable(type, {})
  end

  def create
    @question = Question.find(params[:question_id])
    @question.switch_to(
      type,
      submittable_attributes
    )

    if @question.errors.empty?
      redirect_to @question.survey
    else
      render 'new'
    end
  end

  private

  def submittable_attributes
    params.require(:question).permit(
      submittable_attributes: [
        :minimum, :maximum, :options_attributes
      ]
    ).fetch(:submittable_attributes, {})
  end

  def type
    params[:question][:submittable_type]
  end
end
