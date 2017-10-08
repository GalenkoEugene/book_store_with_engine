# frozen_string_literal: true

module ApplicationHelper
  def authors_to_list(book)
    book.authors.pluck(:name).join(', ')
  end

  def active_class(link_path)
    return '' if request.GET.empty?
    (link_path.include? request.GET.first.join('=')) ? 'active' : ''
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    options = {
        autolink: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        lax_html_blocks: true,
        strikethrough: true,
        superscript: true,
        space_after_headers: true,
        highlight: true,
        underline: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
end
