class InvitationsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @survey_inviter = SurveyInviter.new
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @survey_inviter = SurveyInviter.new(survey_inviter_attributes)
    if @survey_inviter.valid?
      @survey_inviter.deliver
      redirect_to survey_path(@survey), notice: 'Invitation successfully sent'
    else
      @recipients = recipients
      @message = message
      render 'new'
    end
  end

  private

  def survey_inviter_attributes
    params[:invitation].merge(survey: @survey, sender: current_user)
  end

  def recipients
    params[:invitation][:recipients]
  end

  def message
    params[:invitation][:message]
  end
end
