class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  include OutsideDevise

  def update
    change_password = true
    @user = User.find(current_user.id)
    if params[:user][:update_email]
      params[:user].delete('password')
      params[:user].delete('password_confirmation')
      change_password = false
    end

    if change_password
      is_valid = @user.update_with_password(password_params)
    else
      @user.skip_password_validation = true
      is_valid = @user.update_without_password(email_params)
    end

    if is_valid
      bypass_sign_in @user, scope: :user
      redirect_to settings_privacy_path, success: t('user.updated')
    else
      redirect_to settings_privacy_path, danger: @user.errors.full_messages.to_sentence
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def email_params
    params.require(:user).permit(:email)
  end
end
