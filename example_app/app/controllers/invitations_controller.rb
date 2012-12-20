class InvitationsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @survey_inviter = SurveyInviter.new
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @survey_inviter = SurveyInviter.new(survey_inviter_params)

    if @survey_inviter.invite
      redirect_to survey_path(@survey), notice: 'Invitation successfully sent'
    else
      render 'new'
    end
  end

  private

  def survey_inviter_params
    params.require(:survey_inviter).permit(
      :message,
      :recipients
    ).merge(
      sender: current_user,
      survey: @survey
    )
  end
end
