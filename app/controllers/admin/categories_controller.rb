class Admin::CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :admin_user

  def index
    @categories = Category.paginate page: params[:page], per_page: Settings.length.page
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "admin.create_category_success"
      redirect_to [:admin, :categories]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "admin.update_category_success"
      redirect_to [:admin, :category]
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "admin.delete_category_success"
    else
      flash[:danger] = t "admin.delete_category_failed"
    end
    redirect_to admin_categories_url
  end

  private
  def category_params
    params.require(:category).permit :name, :description, :picture
  end

  def set_category
    @category = Category.find params[:id]
  end

end
