module HomeHelper
  def log_out_helper
    divider = '<li class="divider" role="separator"></li>'.html_safe
    divider + li(link_to(t('button.log_out'), main_app.destroy_user_session_path, method: :delete))
  end

  def log_in_up_helper
    if user_signed_in?
      my_account =
        "<li class='dropdown'>"\
          "<a aria-expanded='false' aria-haspopup='true' class='dropdown-toggle' data-toggle='dropdown' href='#' role='button'>#{t('button.my_account')}</a>"\
          "<ul class='dropdown-menu'>" +
        li(link_to(t('button.orders'), cartify.orders_path, class: 'collapse-link')) +
        li(link_to(t('button.settings'), cartify.settings_addresses_path, class: 'collapse-link')) +
        log_out_helper +
        '</ul>'
      my_account.html_safe
    else
      li(link_to(t('button.log_in'), main_app.new_user_session_path)) +
        li(link_to(t('button.sign_up'), main_app.new_user_registration_path))
    end
  end

  def active(index)
    'active' if index.zero?
  end

  private

  def li(teg)
    "<li>#{teg}</li>".html_safe
  end
end
