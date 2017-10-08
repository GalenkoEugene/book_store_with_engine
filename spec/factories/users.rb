# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "email#{i}@email.com" }
    password '123!@#$GGGddd'
  end
end
