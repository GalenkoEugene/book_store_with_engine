# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'End to end checkout process', type: :feature do
  let(:user) { FactoryGirl.create(:user) }
  let(:buy_now_button) { 'input[value="Buy Now"]' }
  let(:shopping_cart_icon) { 'a.shop-link.pull-right.hidden-xs' }

  before do
    FactoryGirl.create(:book)
    FactoryGirl.create_list(:delivery, 3)
  end

  it 'allow to pass all steps in checkout', js: true do
    sign_in(user)
    visit home_path
    find(buy_now_button).click
    wait_for_ajax
    find(shopping_cart_icon).click
    expect(page.current_path).to eq cart_path
    click_on 'Checkout'
    expect(page.current_path).to eq checkout_path(:addresses)

    within('form#new_addresses_form') do
      fill_in 'addresses_form[billing][first_name]', with: 'Monica'
      fill_in 'addresses_form[billing][last_name]', with: 'Bellucci'
      fill_in 'addresses_form[billing][address]', with: 'West 999'
      fill_in 'addresses_form[billing][city]', with: 'NY'
      fill_in 'addresses_form[billing][zip]', with: '32158'
      select('Spain', from: 'addresses_form[billing][country]')
      fill_in 'addresses_form[billing][phone]', with: '+112 34 567 8998'

      fill_in 'addresses_form[shipping][first_name]', with: 'Monica'
      fill_in 'addresses_form[shipping][last_name]', with: 'Bellucci'
      fill_in 'addresses_form[shipping][address]', with: 'West 999'
      fill_in 'addresses_form[shipping][city]', with: 'NY'
      fill_in 'addresses_form[shipping][zip]', with: '32158'
      select('Spain', from: 'addresses_form[billing][country]')
      fill_in 'addresses_form[shipping][phone]', with: '+112 34 567 8998'

      find('input[name="commit"]').click
    end

    expect(page.current_path).to eq checkout_path(:delivery)
    all('.radio-label').first.click
    find('input[name="commit"]').click
    expect(page.current_path).to eq checkout_path(:payment)

    within('form#new_credit_card') do
      fill_in 'credit_card[number]', with: '1234 1234 1234 1234'
      fill_in 'credit_card[name]', with: 'Monica'
      fill_in 'credit_card[mm_yy]', with: '03/19'
      fill_in 'credit_card[cvv]', with: '123'

      find('input[name="commit"]').click
    end

    expect(page.current_path).to eq checkout_path(:confirm)

    find('input[type="submit"]').click
    expect(page.current_path).to eq checkout_path(:complete)
    expect(page).to have_content  "An order confirmation has been sent to #{user.email.capitalize}"
  end
end
