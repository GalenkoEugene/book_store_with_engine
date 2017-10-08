# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorBook, type: :model do
  it { expect(subject).to belong_to :author }
  it { expect(subject).to belong_to :book }
end
