class UsersController < ApplicationController
  before_action :authenticate_admin!, only: :index

  def index
    @users = User.all.by_admin.by_name
  end

  def show
    @user = User.includes(:tracks).find(params[:id])
  end
end
