# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to validate_uniqueness_of :name }
  it { expect(subject).to have_many :author_books }
  it { expect(subject).to have_many :books }
end
