class UnsubscribesController < ApplicationController
  skip_before_action :require_login

  def new
    @unsubscribe = Unsubscribe.new(email: params[:email])
  end

  def create
    @unsubscribe = Unsubscribe.new(unsubscribe_params)
    @unsubscribe.save!
    redirect_to root_url
  end

  protected

  def unsubscribe_params
    params.require(:unsubscribe).permit(:email)
  end
end
