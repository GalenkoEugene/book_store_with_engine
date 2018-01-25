# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Catalog page', type: :feature do
  context 'shared' do
    before { visit catalog_path }
    include_examples 'header and footer'
  end

  describe 'body' do
    before { visit books_path }
    subject { page.find('body') }
    it { expect(subject).to have_content 'Catalog' }
    it { expect(subject).to have_content 'Title A - Z' }
    it { expect(subject).to have_content 'Title Z - A' }
    it { expect(subject).to have_content 'Price: Low to hight' }
    it { expect(subject).to have_content 'Price: Hight to low' }
    it { expect(subject).to have_content 'Newest first' }
    it { expect(subject).to have_content 'Newest first' }
  end

  describe 'View more button' do
    before { FactoryGirl.create(:book) }
    it 'hide view more button', js: true do
      visit books_path
      expect(page).not_to have_content 'View More'
    end

    it 'show view more button', js: true do
      FactoryGirl.create_list(:book, 13)
      visit books_path
      expect(page).to have_content 'View More'
    end
  end

  describe 'active links on book' do
    let(:shop_icon) { page.find('a.hidden-xs>span.shop-icon') }
    before do
      @book = FactoryGirl.create(:book)
      visit catalog_path
    end

    context 'shopping-cart thumb-icon' do
      it 'has empty cart' do
        expect(page).not_to have_css 'span.shop-quantity'
        expect(shop_icon).to have_content ''
      end
    end

    context 'details of the book' do
      it 'has fa-eye thumb-icon' do
        expect(page).to have_css 'i.fa.fa-eye.thumb-icon'
      end

      it 'redirect to view page' do
        find(:linkhref, book_path(@book)).click
        expect(page).to have_http_status(:success)
        expect(page).to have_css 'form.new_order_item'
        expect(page).to have_content @book.title
      end
    end
  end

  describe 'filters' do
    let(:web_design) { Category.find_by_type_of('Web design') }
    let(:web_development) { Category.find_by_type_of('Web development') }
    let(:mobile_development) { Category.find_by_type_of('Mobile development') }
    let(:photo) { Category.find_by_type_of('Photo') }
    let(:filer_menu) { page.find('ul.list-inline.pt-10.mb-25.mr-240') }

    before(:all) do
      FactoryGirl.create_list(:book, 2, category_name: 'Web design')
      FactoryGirl.create_list(:book, 3, category_name: 'Web development')
      FactoryGirl.create_list(:book, 4, category_name: 'Mobile development')
      FactoryGirl.create(:book, category_name: 'Photo')
    end

    before { visit catalog_path }

    context 'All (by default)' do
      it 'show all books' do
        expect(page).to have_selector('div.col-xs-6.col-sm-3', count: 10)
      end
    end

    context 'Web design' do
      it 'show filtered books' do
        filer_menu.find(:filter_by_category, web_design.id).click
        expect(page).to have_selector('div.col-xs-6.col-sm-3', count: 2)
      end
    end

    context 'Web development' do
      it 'show filtered books' do
        filer_menu.find(:filter_by_category, web_development.id).click
        expect(page).to have_selector('div.col-xs-6.col-sm-3', count: 3)
      end
    end

    context 'Mobile development' do
      it 'show filtered books' do
        filer_menu.find(:filter_by_category, mobile_development.id).click
        expect(page).to have_selector('div.col-xs-6.col-sm-3', count: 4)
      end
    end

    context 'Photo' do
      it 'show filtered books' do
        filer_menu.find(:filter_by_category, photo.id).click
        expect(page).to have_selector('div.col-xs-6.col-sm-3', count: 1)
      end
    end
  end
end
