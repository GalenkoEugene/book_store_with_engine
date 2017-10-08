# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Sign up proccess', type: :feature do
  it 'allow sign up for new customer' do
    visit(home_path)
    first(:link, I18n.t('button.sign_up'), minimum: 1).click
    within('form#new_user') do
      fill_in 'user[email]', with: 'example@mail.com'
      fill_in 'user[password]', with: '123456Zz'
      fill_in 'user[password_confirmation]', with: '123456Zz'

      click_on I18n.t('button.sign_up')
    end

    expect(page).to have_current_path(root_path)
    expect(page).to have_content I18n.t('devise.registrations.signed_up')
    expect(page).to have_content I18n.t('button.my_account')
  end
end
