# frozen_string_literal: true

FactoryGirl.define do
  factory :category do
    transient do
      type { FFaker::Lorem.phrase }
    end

    sequence(:type_of) { |i| FFaker::Lorem.phrase + i.to_s }

    after(:create) do |category, evaluator|
      category.type_of= evaluator.type
      category.save
    end
  end
end
