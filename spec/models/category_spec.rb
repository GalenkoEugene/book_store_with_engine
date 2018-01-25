# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  it { expect(subject).to validate_presence_of :type_of }
  it { expect(subject).to validate_uniqueness_of :type_of }

  describe 'scopes' do
    describe '#with_counted_books' do
      before(:all) do
        Category.destroy_all
        FactoryGirl.create_list(:book, 8, category_name: :web)
        FactoryGirl.create_list(:book, 15, category_name: :mobile)
      end

      it { expect(Category.with_counted_books.length).to eq 2 }

      it 'fetch categories with amount of books in them' do
        expect(Category.find_by(type_of: :web).books.count).to eq 8
      end

      it 'fetch categories with amount of books in them' do
        expect(Category.find_by(type_of: :mobile).books.count).to eq 15
      end
    end
  end
end
