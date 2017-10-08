# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  before{ sign_in(user) }

  describe 'GET #index' do
    it 'return success status' do
      get :index
      expect(response).to be_success
      expect(response).to render_template :index
    end
  end

  describe 'PUT #update email' do
    context 'valid email' do
      let(:valid_email_params) do
        { user: { email: 'blabla@valid.mail', update_email: true } }
      end
      before { put :update, params: valid_email_params }

      it 'redirect_to settings privacy' do
        expect(response).to redirect_to settings_privacy_path
      end

      it 'show success message' do
        expect(flash[:success]).to eq I18n.t('user.updated')
      end
    end

    context 'invalid email' do
      let(:invalid_email_params) do
        { user: { email: '--bla@va@#$m', update_email: true } }
      end
      before { put :update, params: invalid_email_params }

      it 'redirect_to settings privacy' do
        expect(response).to redirect_to settings_privacy_path
      end

      it 'show error message' do
        expect(flash[:danger]).to eq 'Email is invalid'
      end
    end
  end

  describe 'update password' do
    let(:valid_password_params) do
      { user: {
        current_password: user.password,
        password: 'validQWERTY1z',
        password_confirmation: 'validQWERTY1z'
       }
     }
    end
    let(:invalid_password_params) do
      { user: {
        current_password: user.password,
        password: 'invalid',
        password_confirmation: 'invalid'
       }
     }
    end

    context 'valid password' do
      before { put :update, params: valid_password_params }

      it 'redirect_to settings privacy' do
        expect(response).to redirect_to settings_privacy_path
      end

      it 'show success message' do
        expect(flash[:success]).to eq I18n.t('user.updated')
      end
    end

    context 'invalid password' do
      before { put :update, params: invalid_password_params }

      it 'redirect_to settings privacy' do
        expect(response).to redirect_to settings_privacy_path
      end

      it 'show error message' do
        expect(flash[:danger]).to eq 'Password is invalid'
      end
    end
  end
end
