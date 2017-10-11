# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'galenko@bookstore.com'
  default template_path: 'mailers'

  def confirm_account(email, password)
    @password = password
    @email = email
    @login_url = new_user_session_url
    mail(to: @email, subject: t('mailer.subject'))
  end
end
