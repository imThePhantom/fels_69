class Admin::WordsController < ApplicationController
  before_action :admin_user
  before_action :init_word, only: [:edit, :update, :destroy]
  before_action :init_category

  def index
    @words = @category.words.paginate page: params[:page], per_page: Settings.length.page
  end

  def new
    @word = Word.new
    Settings.answer_count.times {@word.answers.build}
  end

  def edit
  end

  def create
    @word = @category.words.build word_params
    if @word.save
      flash[:success] = t "admin.create_word_success"
      redirect_to [:admin, :category, :words]
    else
      render :new
    end 
  end  

  def update
    if @word.update_attributes word_params
      redirect_to [:admin, :category, :words]
      flash[:success] = t "admin.update_word_success"
    else
      render :edit
    end
  end

  def destroy
    if @word.destroy
      flash[:success] = t "admin.delete_word_success"
    else
      flash[:danger] = t "admin.delete_word_failed"
    end
    redirect_to [:admin, :category, :words]
  end

  private
  def init_category
    @category = Category.find params[:category_id]
  end

  def init_word
    @word = Word.find params[:id]
  end

  def word_params
    params.require(:word).permit :content, :category_id,
      answers_attributes: [:id, :content, :correct, :_destroy]
  end

end
