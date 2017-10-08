# frozen_string_literal: true

namespace :db do
  namespace :seed do
    desc ' GENERATE DELIVERY TYPES '.center(46, '=')
    task delivery: :environment do
      deliveries = [
        ['Delivery Next Day!',  '1 day',        15.0],
        ['Expressit',           '2 to 3 days',  10.0],
        ['Pick Up in-Store',    '3 to 7 days',  5.0]
      ]

      deliveries.each do |type|
        Delivery.find_or_create_by(name: type[0]) do |deliv|
          deliv.name = type[0]
          deliv.duration = type[1]
          deliv.price = type[2]
        end
      end
      puts ' Delivery types successfully saved to DB '.center(80, '=')
    end
  end
end
