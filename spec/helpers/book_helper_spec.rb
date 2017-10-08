# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookHelper, type: :helper do
  describe '#dimension' do
    it 'returns dimension of the book in right format' do
      @book = FactoryGirl.create(:book, height: 1.0, weight: 2.0, depth: 0.8)
      expect(helper.dimension_for(@book))
        .to eq('H:1.0" x W:2.0" x D:0.8"')
    end
  end
end
