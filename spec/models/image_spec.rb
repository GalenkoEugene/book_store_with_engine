require 'rails_helper'

RSpec.describe Image, type: :model do
  it { expect(subject).to validate_presence_of :file }
  it { expect(subject).to belong_to :book }
end
