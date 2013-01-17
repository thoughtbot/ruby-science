class SummariesController < ApplicationController
  def show
    @survey = Survey.find(params[:survey_id])
  end
end
