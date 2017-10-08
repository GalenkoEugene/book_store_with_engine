# frozen_string_literal: true

namespace :db do
  namespace :seed do
    desc ' GENERATE ORDER_STATUSES '.center(46, '=')
    task order_statuses: :environment do
      statuses = %w[in_progress in_queue in_delivery delivered canceled]
      statuses.each { |status| OrderStatus.find_or_create_by(name: status) }
      puts ' Statuses was successfully generated and saved to DB '.center(80, '=')
    end
  end
end
