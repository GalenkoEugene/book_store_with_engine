# frozen_string_literal: true

module OutsideDevise
  extend ActiveSupport::Concern

  included { helper_method :resource_name, :resource, :devise_mapping }

  def resource_name
    :user
  end

  def resource
    @resource = current_user || User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
