class CategoriesController < ApplicationController
  before_action :logged_in_user

  def index
    @categories = if params[:search_category]
      Category.search_category(params[:search_category]).ordered_by_create_at
        .paginate page: params[:page], per_page: Settings.per_page
    else
      Category.ordered_by_create_at
        .paginate page: params[:page], per_page: Settings.per_page
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @category = Category.find params[:id]
    @words = @category.words.paginate(page: params[:page],
      per_page: Settings.length.page).alphabet
  end

end
