class Admin::WordsController < ApplicationController
  require "csv"
  before_action :admin_user
  before_action :init_word, only: [:edit, :update, :destroy]
  before_action :init_category, except: :create

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
    if params[:file].nil?
      @category = Category.find params[:category_id]
      @word = @category.words.build word_params
      if @word.save
        flash[:success] = t "admin.create_word_success"
        redirect_to [:admin, :category, :words]
      else
        render :new
      end
    else
      import params[:file]
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

  def import file
    count = 0
    begin
      CSV.foreach file.path, headers: true do |f|
        item_hash = f.to_hash
        if csv_file? item_hash
          category = Category.find_or_create_by name: item_hash["category_name"]
          count = create_word(item_hash["word_content"],
            item_hash["true_answer"], item_hash["other_answers"], category.id, count)
        end
      end
      check_update count
      redirect_to categories_path
    rescue Exception
      error
    end
  end

  def csv_file? item_hash
    !(item_hash["category_name"].nil? &&
      item_hash["word_content"].nil? &&
      item_hash["true_answer"].nil? &&
      item_hash["other_answers"].nil?)
  end

  def create_word word_content, true_answer, other_answers, id, count
    word = Word.create content: word_content, category_id: id
    Answer.create content: true_answer, word_id: word.id, correct: true
    other_answers.to_s.split("/").each do |ans|
      Answer.create content: ans, word_id: word.id, correct: false unless ans.nil?
    end
    count += 1
  end

  def check_update count
    if count == 0
      flash[:danger] = t("admin.no_changes").join(" ")
    else
      flash[:success] = t "admin.import_success"
    end
  end

  def error
    flash[:danger] = t "admin.flash_danger"
    redirect_to categories_path
  end
end
