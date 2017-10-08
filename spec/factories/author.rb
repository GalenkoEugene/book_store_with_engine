# frozen_string_literal: true

require 'ffaker'

FactoryGirl.define do
  factory :author do
    sequence(:name)  { |i| FFaker::Book.author + i.to_s }
  end
end
