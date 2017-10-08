ActiveAdmin.register Book do
  active_admin_importable
  includes :authors, :category, :images
  permit_params :id, :category_id, :title, :price, :description, :materials, :height, :weight, :depth, :published_at, :active, author_ids: [], images_attributes: [:id, :file, :book_id, :_destroy]


  index do
    selectable_column
    column I18n.t('admin.book.image') do |book|
      image_tag(book.images.first&.file&.thumb&.url || 'sample.jpg', size: '50x60')
    end
    column(I18n.t('admin.book.category')) { |book| book.category&.type_of }
    column :title
    column(I18n.t('admin.book.author')) { |book| authors_to_list(book) }
    column(I18n.t('admin.book.description')) do |book|
      truncate(book.description, length: 75)
    end
    column :price { |book| number_to_currency book.price }
    column do |book|
      (link_to I18n.t('admin.book.view'),
        edit_admin_book_path(book)) + ' - ' +
      (link_to I18n.t('admin.book.delete'),
        admin_book_path(book), method: :delete,
          data: { confirm: I18n.t('admin.book.confirm') })
    end
  end

  form html: { multipart: true } do |f|
    f.inputs I18n.t('admin.book.details') do
      f.input :title
      f.input :authors
      f.input :active
      f.input :price
      f.input :category, as: :select, collection:
        Category.pluck(:type_of, :id), include_blank: false
      f.input :description
      f.input :materials
      f.input :height
      f.input :weight
      f.input :depth
      f.input :published_at
      f.has_many :images, allow_destroy: true do |img|
        img.input :file, as: :file, hint:
          (image_tag(img.object.file.thumb.url) if img.object.file.present?)
      end
    end
    f.actions
  end
end
