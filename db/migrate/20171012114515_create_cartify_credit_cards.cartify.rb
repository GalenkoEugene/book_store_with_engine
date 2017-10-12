# This migration comes from cartify (originally 20171005131198)
class CreateCartifyCreditCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cartify_credit_cards do |t|
      t.string :number
      t.string :name
      t.string :mm_yy
      t.string :cvv

      t.timestamps
    end
  end
end
