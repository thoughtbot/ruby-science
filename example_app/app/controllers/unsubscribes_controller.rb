class UnsubscribesController < ApplicationController
  skip_before_filter :authorize

  def new
    @unsubscribe = Unsubscribe.new(email: params[:email])
  end

  def create
    @unsubscribe = Unsubscribe.new(params[:unsubscribe])
    @unsubscribe.save!
    redirect_to root_url
  end
end
