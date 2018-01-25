# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :skip_password_validation
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  validates_uniqueness_of :uid, unless: Proc.new { provider.nil? }, scope: :provider
  validates :email, format: {
    with: /\A[^-.]\w+[-.]?(\w+[-!#$%&'*+\/=?^_`{|}~.]\w+)*[^-]@([\w\d]+)\.([\w\d]+)\z/
  }
  validates :password, format: {
    with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)\S{8,}\z/
  }, unless: :skip_password_validation

  has_many :reviews
  has_many :orders, class_name: 'Cartify::Order', foreign_key: :user_id
  has_one :billing, class_name: 'Cartify::Billing', foreign_key: :user_id
  has_one :shipping, class_name: 'Cartify::Shipping', foreign_key: :user_id
  has_many :addresses, class_name: 'Cartify::Address', foreign_key: :user_id

  def order_in_progress
    self.orders.where_status('in_progress').first
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      full_name = auth.info.name.split(' ')
      user.email = auth.info.email
      user.first_name = full_name[0]
      user.last_name = full_name[1]
      user.image = auth.info.image
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.new_with_session(params, session)
    session_fb_data = session['devise.facebook_data']
    super.tap do |user|
      if data = session_fb_data && session_fb_data['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  def soft_delete
    assign_attributes(updated_params)
    save(validate: false)
  end

  def active_for_authentication?
    super && !deleted_at
  end

  def inactive_message
    !deleted_at ? super : :deleted_account
  end

  private

  def updated_params
    { email: "#{self.email}_#{Time.current}", deleted_at: Time.current }
  end
end
