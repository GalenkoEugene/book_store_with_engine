# frozen_string_literal: true

namespace :db do
  namespace :seed do
    desc ' GENERATE ALL DATA '.center(46, '=')
    task default_data: %i[order_statuses coupons delivery] do
      puts ' DONE! '.center(80, '=')
    end
  end
end
