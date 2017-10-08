# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Log in proccess', type: :feature do
  it 'allow log in for customer' do
    @user = FactoryGirl.create(:user)

    visit(home_path)
    first(:link, I18n.t('button.log_in'), minimum: 1).click
    within('form#new_user') do
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password

      click_on I18n.t('button.back_to_store')
    end

    expect(page).to have_current_path(root_path)
    expect(page).to have_content I18n.t('devise.sessions.signed_in')
    expect(page).to have_content I18n.t('button.my_account')
  end
end
