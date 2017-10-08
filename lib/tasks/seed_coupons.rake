# frozen_string_literal: true

namespace :db do
  namespace :seed do
    desc ' GENERATE COUPONS '.center(46, '=')
    task coupons: :environment do
      (1..7).each do |coupon|
        Coupon.find_or_create_by(name: "D1234567890000#{coupon}") do |item|
          item.name = "D1234567890000#{coupon}"
          item.value = "#{coupon}.00".to_f
        end
      end
      puts ' Coupons was successfully saved to DB '.center(80, '=')
    end
  end
end
