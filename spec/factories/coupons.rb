FactoryGirl.define do
  factory :coupon do
    transient do
      value 9.99
      name 'D12345678900000'
    end

    before(:create) do |coupon, evaluator|
      coupon.value= evaluator.value
      coupon.name= evaluator.name
    end
  end
end
