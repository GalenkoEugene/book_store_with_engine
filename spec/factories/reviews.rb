FactoryGirl.define do
  factory :review do
    transient do
      status false
    end

    score 5
    context 'review context'
    association :user
    association :book

    before(:create) do |review, evaluator|
      review.status= evaluator.status
    end
  end
end
