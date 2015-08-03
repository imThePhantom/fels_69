class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :following, :followers]
  before_action :init_user, only: [:show, :edit, :update, :correct_user, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  def show
    @lessons = @user.lessons.paginate page: params[:page], per_page: Settings.length.page
  end

  def index
    @users = User.paginate(page: params[:page], per_page: Settings.length.page).order "name"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t"welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end
  
  def update
    if @user.update_attributes user_params
      flash[:success] = t"update_profile"
      redirect_to @user
    else
      render :edit
    end
  end

  private 
  def user_params
    params.require(:user).permit :name, :email, :password,
                          :password_confirmation, :avatar
  end
  
  def init_user
    @user = User.friendly.find params[:id]
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end
end
