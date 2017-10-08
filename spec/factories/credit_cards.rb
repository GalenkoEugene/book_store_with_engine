FactoryGirl.define do
  factory :credit_card do
    number '1234567891234567'
    name 'name on card'
    mm_yy '12/12'
    cvv 123
  end
end
