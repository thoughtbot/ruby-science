class InvitationsController < ApplicationController
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  def new
    @survey = Survey.find(params[:survey_id])
  end

  def create
    @survey = Survey.find(params[:survey_id])

    @recipients = params[:invitation][:recipients]
    recipient_list = @recipients.gsub(/\s+/, '').split(/[\n,;]+/)

    @invalid_recipients = recipient_list.map do |item|
      unless item.match(EMAIL_REGEX)
        item
      end
    end.compact

    @message = params[:invitation][:message]

    if @invalid_recipients.empty? && @message.present?
      recipient_list.each do |email|
        invitation = Invitation.create(
          survey: @survey,
          sender: current_user,
          recipient_email: email,
          status: 'pending'
        )
        Mailer.invitation_notification(invitation, @message)
      end

      redirect_to survey_path(@survey), notice: 'Invitation successfully sent'
    else
      render 'new'
    end
  end
end
