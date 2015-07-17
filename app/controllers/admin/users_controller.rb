class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_user

  def index
    @users = User.paginate page: params[:page], per_page: Settings.length.page
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to [:admin, @user]
      flash[:success] = t "admin.create_user_success"
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      redirect_to [:admin, @user]
      flash[:success] = t "admin.update_user_success"
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "admin.delete_user_success"
    else
      flash[:danger] = t "admin.delete_user_failed"
    end
    redirect_to admin_users_url
  end

  private
  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit :name,:email,
      :password,:password_confirmation,:admin
  end
end
