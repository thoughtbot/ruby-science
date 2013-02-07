class TypesController < ApplicationController
  def new
    @question = Question.find(params[:question_id])
    assign_type
    @new_question = type.constantize.new
  end

  def create
    @question = Question.find(params[:question_id])
    @new_question = @question.switch_to(type, params[:question], {})

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

  def type
    params[:question][:type]
  end
end
