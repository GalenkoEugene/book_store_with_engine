# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:book) { FactoryGirl.create(:book) }

  describe 'GET #index' do
    before { get :index }

    it 'return a success response' do
      expect(response).to be_success
      expect(response).to render_template :index
    end

    it 'assign @books' do
      expect(assigns(:books)).not_to be_nil
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: book.to_param } }

    it 'return a success response' do
      expect(response).to be_success
      expect(response).to render_template :show
    end

    it 'assign @reviews' do
      expect(assigns(:reviews)).not_to be_nil
    end
  end
end
