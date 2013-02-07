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
    if params[:question][:submittable_attributes]
      params[:question].
        require(:submittable_attributes).
        permit(:minimum, :maximum)
    else
      {}
    end
  end

  def type
    params[:question][:submittable_type]
  end
end
