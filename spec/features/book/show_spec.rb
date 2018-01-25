# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Book page', type: :feature do
  before :each do
    @book = FactoryGirl.create(:book_with_review)
  end

  context 'shared' do
    before { visit book_path(@book) }
    include_examples 'header and footer'
  end

  describe 'body' do
    before { visit book_path(@book) }
    subject { page.find('body') }
    it { expect(subject).to have_content 'Back to results' }
    it { expect(subject).to have_content 'Year of publication' }
    it { expect(subject).to have_content 'Dimensions' }
    it { expect(subject).to have_content @book.title }
    it { expect(subject).to have_content @book.materials }
    it { expect(subject).to have_content @book.published_at }
  end

  context 'short description' do
    it "'Read More' button absent", js: true do
      @book.description= 'text ' * 3
      @book.save!
      visit book_path(@book)
      expect(page).not_to have_content 'Read More'
    end
  end

  context 'long description' do
    it "'Read More' button present", js: true do
      @book.description= 'text ' * 400
      @book.save!
      visit book_path(@book)
      expect(page).to have_content 'Read More'
    end
  end

  describe 'Add to Cart' do
    let(:shop_icon) { page.find('a.hidden-xs>span.shop-icon') }
    let(:plus) { find(:xpath, ".//a[child::i[contains(@class,\"fa-plus\")]]") }
    let(:minus) { find(:xpath, ".//a[child::i[contains(@class,\"fa-minus\")]]") }
    before { visit book_path(@book) }

    it 'has no items in cart' do
      expect(page).not_to have_css 'span.shop-quantity'
      expect(shop_icon).to have_content ''
    end

    context 'amount of books' do
      it 'increase quantity', js: true do
        plus.trigger('click')
        expect(page.find('#order_item_quantity').value).to eq '1'
      end

      it 'can`t be less then 1', js: true do
        minus.trigger('click')
        expect(page.find('#order_item_quantity').value).to eq '1'
      end
    end

    it 'add four items into cart', js: true do
      fill_in 'order_item[quantity]', with: '4'
      click_on I18n.t('button.add_to_cart')
      expect(shop_icon).to have_content '4'
    end

    it 'add one item into cart', js: true do
      click_on I18n.t('button.add_to_cart')
      expect(shop_icon).to have_content '1'
    end
  end

  describe 'Review' do
    let(:post_review_form) { page.find('#post_review') }
    before do
      sign_in_as_user
      visit book_path(@book)
    end

    it 'show form for review' do
      expect(page).to have_content I18n.t('review.write')
      expect(page).to have_css('#post_review')
    end

    it 'can rate book' do
      expect(page).to have_content('Score')
    end

    it 'can post revire' do
      fill_in 'review[context]', with: 'It was the best book in my life'
      click_on I18n.t('button.post')
      expect(page).to have_content I18n.t('review.thanks_message')
    end

    it 'do not save unpermited review' do
      fill_in 'review[context]', with: '!@#$#%^$^%&^**&((/'
      click_on I18n.t('button.post')
      expect(page).to have_content I18n.t('review.smth_went_wrong')
    end

    context 'User Log Out' do
      before { find(:log_out).click }

      it 'cannot write a review' do
        expect(page).not_to have_content I18n.t('review.write')
      end

      it 'hide form' do
        expect(page).not_to have_css('#post_review')
      end
    end
  end

  describe 'Back to results' do
    let(:go_back) { page.find('a.general-back-link') }
    let(:visit_book_path_and_click_go_back) do
      visit book_path(@book)
      expect(page.current_path).to eq book_path(@book)
      go_back.click
    end

    context "come from 'catalog' page" do
      it 'return back to catalog' do
        visit catalog_path
        expect(page.current_path).to eq catalog_path
        visit_book_path_and_click_go_back
        expect(page.current_path).to eq catalog_path
      end
    end

    context "come from 'home' page" do
      it 'return back to home' do
        visit home_path
        expect(page.current_path).to eq home_path
        visit_book_path_and_click_go_back
        expect(page.current_path).to eq home_path
      end
    end

    context "come from 'cart' page" do
      it 'return to cart path', js: true do
        visit cartify.cart_path
        expect(page.current_path).to eq cartify.cart_path
        visit_book_path_and_click_go_back
        expect(page.current_path).to eq cartify.cart_path
      end
    end
  end
end
