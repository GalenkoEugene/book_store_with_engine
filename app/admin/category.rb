ActiveAdmin.register Category, as: I18n.t('admin.category.book_category') do
  active_admin_importable
  permit_params :type_of
  includes :books

  index do
    selectable_column
    column I18n.t('admin.category.name'), :type_of
    column do |category|
      (link_to I18n.t('admin.category.edit'),
        edit_admin_book_category_path(category)) + ' - ' +
      (link_to I18n.t('admin.category.delete'),
        admin_book_category_path(category), method: :delete,
        data: { confirm:
          I18n.t('admin.category.are_you_sure') +
          "\nThey are associated with #{category.books.count} of books"
        })
    end
  end
end
