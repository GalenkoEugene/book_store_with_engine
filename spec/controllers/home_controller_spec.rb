# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let!(:books) { FactoryGirl.create_list(:book, 7) }

  describe 'GET #index' do
    before { get :index }

    it 'assign @latest_books' do
      expect(assigns(:latest_books)).to match_array(books.last(3))
      expect(response).to render_template :index
    end

    it 'assign @best_sellers' do
      expect(assigns(:best_sellers)).not_to be_nil
      expect(response).to be_success
    end
  end
end
