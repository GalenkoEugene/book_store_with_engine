# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shipping, type: :model do
  include_examples 'address_validations'
end
