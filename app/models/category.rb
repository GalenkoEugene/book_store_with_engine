# frozen_string_literal: true

# categories
class Category < ApplicationRecord
  has_many :books, dependent: :nullify
  validates :type_of, presence: true, uniqueness: true

  scope :with_counted_books, -> { joins(:books).select('categories.*, count(books.id) as books_count').group('categories.id') }
end
