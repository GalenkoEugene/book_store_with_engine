# frozen_string_literal: true

module CurrentSession
  attr_reader :back

  extend ActiveSupport::Concern
  included do
    before_action :set_back_path
  end

  def set_back_path
    session[:previous_request_url] = session[:current_request_url]
    session[:current_request_url] = request.path if request.path.match /\/(catalog|home|cart|checkout|orders)/
    @back = session[:previous_request_url]
  end
end
