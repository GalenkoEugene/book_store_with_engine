FactoryGirl.define do
  factory :delivery do
    name { %w[train bus plain telepor].sample }
    price 777.0
    duration 'infinity..'
  end
end
