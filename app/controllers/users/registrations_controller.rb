# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    UserMailer.confirm_account(*sending_params).deliver_later if current_user
  end

  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
  end

  private

  def sending_params
    [params[:user][:email], params[:user][:password]]
  end
end
