# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Cart page', type: :feature do
  before :each { visit cart_path }
  include_examples 'header and footer'

  describe 'body' do
    subject { page.find('body') }
    it { expect(subject).to have_content 'Cart' }
    it { expect(subject).to have_selector :link_or_button, 'Checkout' }
    it { expect(subject).to have_selector :link_or_button, 'Update cart' }
    it { expect(subject).to have_content 'Order Summary' }
    it { expect(subject).to have_content 'SubTotal:' }
    it { expect(subject).to have_content 'Coupon:' }
    it { expect(subject).to have_content 'Order Total:' }
    it { expect(subject).to have_content 'Coupon' }
    it { expect(subject).to have_content 'Quantity' }
  end

  describe 'update cart' do
    let(:shop_icon) { page.find('a.hidden-xs>span.shop-icon') }
    let(:qqty_input) do
      within('div.hidden-xs table') { find('input.form-control.quantity-input') }
    end

    let(:plus) do
      within('div.hidden-xs table') { find("#order_#{@order_item.id}_plus", visible: true) }
    end

    let(:minus) do
      within('div.hidden-xs table') { find("#order_#{@order_item.id}_minus", visible: true) }
    end

    before do
      @order_item = FactoryGirl.create(:order_item)
      inject_session order_id: @order_item.order.id
      visit cart_path
    end

    context 'click plus', js: true do
      it 'increase amount of books in shopping cart' do
        expect(shop_icon).to have_content '1'
        plus.click
        sleep 0.2
        expect(shop_icon).to have_content '2'
      end

      it 'increase Quantity field' do
        expect(qqty_input.value).to eq '1'
        plus.click
        sleep 0.2
        expect(qqty_input.value).to eq '2'
      end
    end

    context 'click minus', js: true do
      before do
        plus.click
        sleep 0.2
      end

      it 'decrease amount of books in shopping cart' do
        expect(shop_icon).to have_content '2'
        minus.click
        sleep 0.2
        expect(shop_icon).to have_content '1'
      end

      it 'decrease Quantity field' do
        expect(qqty_input.value).to eq '2'
        minus.click
        sleep 0.2
        expect(qqty_input.value).to eq '1'
      end

      it 'Quantity can not be less then one' do
        3.times do
          minus.click
          sleep 0.2
        end
        expect(qqty_input.value).to eq '1'
      end
    end

    context 'click Item details' do
      it 'go to book show page' do
        page.find('td>a.text-as-link').click
        expect(page.current_path).to eq book_path(@order_item.book)
        expect(page).to have_content 'Back to results'
      end

      context 'click Back to results' do
        let(:go_back) { page.find('a.general-back-link') }

        it 'return back to shopping cart' do
          page.find('td>a.text-as-link').click
          expect(page.current_path).to eq book_path(@order_item.book)
          go_back.click
          expect(page.current_path).to eq cart_path
        end
      end
    end

    describe 'Coupon' do
      context 'upply valid coupon' do
        let(:coupon) { FactoryGirl.create(:coupon, name: 'valid_coupon_ok', value: 99.9) }

        before do
          fill_in I18n.t('cart.coupon'), with: coupon.name
          click_on I18n.t('cart.update')
        end

        it 'show success message' do
          expect(page).to have_content I18n.t('flash.coupon_applied')
        end

        it 'set discount' do
          expect(page).to have_content coupon.value
        end
      end

      context 'try to apply invalid coupon' do
        let(:invalid_coupon) { 'invalid_coupon' }

        before do
          fill_in I18n.t('cart.coupon'), with: invalid_coupon
          click_on I18n.t('cart.update')
        end

        it 'show error message' do
          expect(page).to have_content I18n.t('flash.fake_coupon')
        end
      end
    end

    describe 'Checkout' do
      context 'guest user' do
        it 'transferred to the Checkout Login page', js: true do
          visit home_path
          find('input[value="Buy Now"]').click
          find('a.shop-link.pull-right.hidden-xs').click
          click_on 'Checkout'
          expect(page).to have_content 'Returning Customer'
          expect(page).to have_content 'New Customer'
          expect(page).to have_content 'Quick Register'
        end
      end

      context 'loged in user' do
        before { sign_in_as_user }

        context 'empty cart' do
          it 'redirect to catalog page' do
            find('a.shop-link.pull-right.hidden-xs').click
            click_on 'Checkout'
            expect(page).to have_content I18n.t('page.book.index.catalog')
          end
        end

        it 'transferred to the Checkout page, the Addresses tab', js: true do
          find('input[value="Buy Now"]').click
          find('a.shop-link.pull-right.hidden-xs').click
          click_on 'Checkout'
          expect(page).to have_content I18n.t('settings.billing')
          expect(page).to have_content I18n.t('settings.shipping')
        end
      end
    end
  end
end
