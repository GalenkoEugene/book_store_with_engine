# This migration comes from cartify (originally 20171005131200)
class CreateCartifyOrderStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :cartify_order_statuses do |t|
      t.string :name
    end
  end
end
