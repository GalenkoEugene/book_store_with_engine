class CreateAuthorBooks < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up   do
        create_table :author_books do |t|
          t.references :author, foreign_key: true, index: true
          t.references :book, foreign_key: true, index: true
        end
        drop_table :authors_books
      end

      dir.down do
        drop_table :author_books
        create_table :authors_books do |t|
          t.references :author, foreign_key: true, index: true
          t.references :book, foreign_key: true, index: true
        end
      end
    end
  end
end
