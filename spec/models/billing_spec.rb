# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Billing, type: :model do
  include_examples 'address_validations'
end
