class LessonsController < ApplicationController
  before_action :init_lesson, only: [:edit, :update]
  before_action :init_category, only: [:create, :edit, :update]
  before_action :logged_in_user
  
  def create
    @lesson = Lesson.new category_id: @category.id, user_id: current_user.id
    if @lesson.save
      flash[:success] = t "create_lesson_success"
      redirect_to edit_category_lesson_path(@category, @lesson)
    else
      full_messages = ""
      @lesson.errors.full_messages.each do |message|
        full_messages += message
      end
      flash[:danger] = full_messages
      redirect_to categories_path
    end
  end

  def edit
    @time_remain = @lesson.time_remain
    @time_over = @lesson.time_remain <= 0
  end

  def update
    if @lesson.update_attributes lesson_params
      flash[:success] = t "update_lesson_success"
      redirect_to edit_category_lesson_path
    else
      flash[:danger] = t "update_lesson_fail"
      redirect_to categories_path
    end
  end

  private
  def init_lesson
    @lesson = Lesson.find params[:id]
  end

  def init_category
    @category = Category.find params[:category_id]
  end

  def lesson_params
    params.require(:lesson).permit results_attributes: [:id, :word_id, :answer_id]
  end

end
