class ApplicationController < ActionController::Base
  before_action :gon_user

  private

  def gon_user
    gon.user = current_user if signed_in?
  end
end
