# frozen_string_literal: true

require 'ffaker'

FactoryGirl.define do
  factory :book do
    transient do
      cost 555.55
      category_name { FactoryGirl.create(:category).id }
    end

    price 1.0
    sequence(:title)  { |i| FFaker::Book.title + i.to_s }
    description FFaker::Book.description
    published_at 2015
    height 1.1
    weight 2.0
    depth 0.8
    materials 'paper, silk'
    category

    before(:create) do |book, evaluator|
      book.category_id= (Category.find_by_type_of(evaluator.category_name) ||
        FactoryGirl.create(:category, type: evaluator.category_name)).id
    end

    after(:create) do |book, evaluator|
      book.price= evaluator.cost
    end

    factory :book_with_review do
      after(:create) do |book, _evaluator|
        create_list(:review, 3, book_id: book.id)
      end
    end
  end
end
