module BookHelper
  def dimension_for(book)
    "H:#{book.height}\" x W:#{book.weight}\" x D:#{book.depth}\""
  end

  def group_by4in_row(books)
    set = ''
    a = books.in_groups_of(4) do |group|
      set << '<div class = "row"> '
      group.each do |book|
        set << (render partial: 'books/book', locals: { book: book }) unless book.nil?
      end
      set << ' </div>'
    end
    set.html_safe
  end

  def active_filter
    case request.GET[:filter]
    when 'popular' then t('button.popular_first')
    when 'price_up' then t('button.low_to_hight')
    when 'price_down' then t('button.hight_to_low')
    when 'a_z' then t('button.title_A-Z')
    when 'z_a' then t('button.title_Z-A')
    else
      t('button.newest_first')
    end
  end

  def img_of(book)
    return default_image unless book.images.any?
    book.images.first.file.catalog_size.url || default_image
  end

  def view_img(book, identifier = :first)
    return default_image unless book.images.any?
    book.images.send(identifier).file.view_size.url
  end

  def carousel_img(book)
    return default_image unless book.images.any?
    book.images.first.file.slider_size.url
  end

  def small_images(book)
    return unless book.images[1]
    book.images[1..3].map do |image|
      "<a class='img-link' href='#'>\
      #{image_tag(image.file.view_size.url, alt: book.title)} </a>"
    end.join.html_safe
  end

  def go_back
    @back || :back
  end

  private

  def default_image
    'sample.jpg'
  end
end
