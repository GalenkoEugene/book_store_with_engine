# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  context 'validations' do
    it { expect(subject).to validate_presence_of :title }
    it { expect(subject).to validate_presence_of :price }
    it { expect(subject).to validate_presence_of :description }
    it { expect(subject).to validate_presence_of :published_at }
    it { expect(subject).to validate_presence_of :height }
    it { expect(subject).to validate_presence_of :weight }
    it { expect(subject).to validate_presence_of :depth }
    it { expect(subject).to validate_presence_of :materials }
    it {
      expect(subject).to validate_numericality_of(:price)
        .is_greater_than_or_equal_to 0.01
    }
    it {
      expect(subject).to validate_numericality_of(:published_at)
        .is_greater_than_or_equal_to(1900)
        .is_less_than_or_equal_to Time.now.year
    }
    it { expect(subject).to validate_numericality_of(:height) }
    it { expect(subject).to validate_numericality_of(:weight) }
    it { expect(subject).to validate_numericality_of(:depth) }
    it { expect(subject).to validate_length_of(:title).is_at_most 120 }
    it { expect(subject).to validate_length_of(:materials).is_at_most 80 }
    it {
      expect(subject).to validate_length_of(:description)
        .is_at_least(5).is_at_most(2000)
    }
    it { expect(subject).to have_many :author_books }
    it { expect(subject).to have_many :authors }
    it { expect(subject).to validate_presence_of :category_id }
  end
end
