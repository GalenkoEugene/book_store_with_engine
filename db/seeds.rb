# frozen_string_literal: true

require 'ffaker'
AuthorBook.delete_all
Author.delete_all
Book.delete_all
Category.delete_all
OrderStatus.delete_all
Order.delete_all
OrderItem.delete_all
Coupon.delete_all
AdminUser.delete_all

authors, books = [], []
type_of = ['Mobile development', 'Photo', 'Web design', 'Web development']

type_of.each{ |type| Category.create(type_of: type) }

15.times { authors << { name: FFaker::Book.author } }

95.times do |item|
  books << {
    title: FFaker::Book.title + item.to_s,
    price: sprintf('%0.2f', rand(3..150.0)),
    description: FFaker::Book.description,
    published_at: rand(1900..2017),
    height: sprintf('%0.1f', rand(0..9.0)),
    weight: sprintf('%0.1f', rand(0..9.0)),
    depth: sprintf('%0.1f', rand(0..9.0)),
    materials: FFaker::Lorem.words(rand(1..5)).join(', '),
    category_id: Category.all.sample.id
  }
end

authors_in_db = Author.create!(authors)

books.size.times do |item|
  new_book = authors_in_db.sample.books.create!(books[item])
  # new_book.authors.create!(name: FFaker::Book.author)
  new_book.authors << authors_in_db.sample
end

statuses = %w[in_progress in_queue in_delivery delivered canceled]
statuses.each { |status| OrderStatus.create(name: status) }

order = Order.create!(order_status_id: OrderStatus.first.id, total: 33.33, subtotal: 33.33)
OrderItem.create!(total_price: 66.66, quantity: 2, book_id: Book.last.id, unit_price: 33.33, order_id: order.id)

(1..7).each do |coupon|
  Coupon.create(name: "D1234567890000#{coupon}", value: "#{coupon}.00".to_f)
end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
