ActiveAdmin.register Author do
  active_admin_importable
  permit_params :name
  includes :author_books, :books

  index do
    selectable_column
    column :name
    column do |author|
      (link_to I18n.t('admin.category.edit'), edit_admin_author_path(author)) +
      ' - ' +
      (link_to I18n.t('admin.category.delete'), admin_author_path(author),
        method: :delete, data: { confirm:
          I18n.t('admin.category.are_you_sure') +
          "\nThey are associated with #{author.books.count} of books"
        })
    end
  end

  filter :name, as: :select
  filter :books_title, as: :select, collection: Book.all
end
