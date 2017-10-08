# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersQuery, type: :model do
  before(:all) do
    @user = FactoryGirl.create(:user)
    in_delivery = FactoryGirl.create(:order_status, name: 'in_delivery')
    3.times { FactoryGirl.create(:order, :in_progress, user: @user) }
    2.times { FactoryGirl.create(:order, order_status: in_delivery, user: @user) }
  end
  subject { OrdersQuery.new(@user.orders) }

  it 'unless give set to query it will work with none Order' do
    expect(OrdersQuery.new().relation).to eq Order.none
  end

  it 'return self if no matches' do
    expect(subject.run('no such status')).to eq @user.orders
  end

  it 'return set of orders with one status' do
    subj = subject.run('in_progress').pluck(:order_status_id)
    expect(subj.uniq.size).to eq 1
  end

  it 'return set of orders with one status only In Progress' do
    subj = subject.run('in_progress').pluck(:order_status_id)
    expect(OrderStatus.find(subj.first).name).to eq 'in_progress'
  end
end
