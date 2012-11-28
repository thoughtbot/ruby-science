class SurveysController < ApplicationController
  def new
    @survey = Survey.new
  end

  def create
    survey_params = params.require(:survey).permit(:title)
    @survey = Survey.new(survey_params)
    @survey.author = current_user
    if @survey.save
      redirect_to [:surveys]
    else
      render :new
    end
  end

  def index
    @surveys = Survey.all
  end

  def show
    @survey = Survey.find(params[:id])
    @questions = @survey.questions
    @completion = @survey.completions.new
  end
end
