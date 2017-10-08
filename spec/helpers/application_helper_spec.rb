# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#authors_to_list' do
    it 'returns authors in one line' do
      @book = FactoryGirl.create(:book) do |book|
        %w[Konan Doyle].each { |writer| book.authors.create(name: writer) }
      end
      expect(helper.authors_to_list(@book)).to eq('Konan, Doyle')
    end
  end

  describe '#shop_icon_quantity' do
    let(:order) { double('curent_order') }
    %w[1 2 4 8 16 56].each do |qqty|
      it "wrap #{qqty} quantity in span" do
        order_item = FactoryGirl.create(:order_item, quantity: qqty)
        allow(order).to receive(:order_items).and_return([order_item])
        expect(helper.shop_icon_quantity(order))
          .to eq("<span class='shop-quantity'>#{qqty}</span>")
      end
    end
  end
end
