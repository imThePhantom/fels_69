class WordsController < ApplicationController
  
  def index
    @categories = Category.all
    @words = if params[:search] || params[:filter_state]
      Word.filter_category(params[:category_id]).search(params[:search])
      .paginate(page: params[:page], per_page: Settings.length.page)
      .send(params[:filter_state], current_user).alphabet
    else
      Word.paginate(page: params[:page], per_page: Settings.length.page).alphabet
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

end
