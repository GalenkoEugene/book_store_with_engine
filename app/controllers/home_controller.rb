# frozen_string_literal: true

# bestsellers and new_books are here
class HomeController < ApplicationController
  def index
    @latest_books = Book.latest
    @best_sellers = Book.best_sellers
  end
end
