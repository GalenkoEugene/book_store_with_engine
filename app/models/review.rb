# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user, :book, :context, :score, presence: true
  validates :score,
    numericality: {
                    only_integer: true,
                    greater_than_or_equal_to: 1,
                    less_than_or_equal_to: 5
                  }
  validates :context, format: { with: /\A[a-zA-Z\d\s]+[-!#$%&'*+\/=?^_`{|}~.,]?[a-zA-Z\d\s]*\z/ }

  scope :approved, -> { where(status: true).order(created_at: :desc) }

  def approve!
    update(status: true)
  end

  def reject!
    update(status: false)
  end
end
