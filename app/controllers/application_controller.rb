# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include CurrentSession
  protect_from_forgery with: :exception
  before_action :categories

  def categories
    @categories = Category.with_counted_books || Category.none
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, notice: exception.message
  end
  add_flash_types :danger, :warning, :success
end
