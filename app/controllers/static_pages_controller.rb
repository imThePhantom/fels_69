class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @lessons = current_user.feed.paginate page: params[:page], per_page: Settings.length.page
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
