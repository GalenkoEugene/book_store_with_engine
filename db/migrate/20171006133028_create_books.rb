# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.decimal :price, precision: 8, scale: 2
      t.text :description
      t.integer :published_at
      t.string :dimension
      t.string :materials
      t.decimal :height, precision: 4, scale: 1
      t.decimal :weight, precision: 4, scale: 1
      t.decimal :depth, precision: 4, scale: 1
      t.boolean :active, default: true
      t.belongs_to :category, foreign_key: true, null: true

      t.timestamps
    end
  end
end
