class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session])
  end
end
