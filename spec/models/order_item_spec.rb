require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  it { expect(subject).to belong_to :book }
  it { expect(subject).to belong_to :order }

  it { expect(subject).to validate_presence_of :quantity }
  it { expect(subject).to belong_to :book }
  it { expect(subject).to belong_to :order }

  let(:book) { FactoryGirl.create(:book, price: 12.66) }
  let(:params) { [:order_item, unit_price: 77.77, book_id: book.id, quantity: 2] }

  it 'return book price before adding to cart' do
    order_i = FactoryGirl.build(*params)
    expect(order_i.unit_price).to eq 12.66
  end

  it 'freeze price when order is saving' do
    order_i = FactoryGirl.create(*params)
    expect(order_i.unit_price).to eq 12.66
  end

  it 'return total price' do
    order_i = FactoryGirl.create(*params)
    expect(order_i.total_price).to eq 25.32
  end

  context "callbacks" do
    it { expect(subject).to callback(:finalize).before(:save) }
  end
end
