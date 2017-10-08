require 'rails_helper'

RSpec.describe Review, type: :model do
  it { expect(subject).to validate_presence_of :score }
  it { expect(subject).to validate_presence_of :context }
  it {
    expect(subject).to validate_numericality_of(:score).only_integer
      .is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5)
  }
  it { expect(subject).to belong_to :user }
  it { expect(subject).to belong_to :book }
  it { expect(subject).to allow_value('Hello, world').for(:context) }
  it { expect(subject).not_to allow_value('H#llo, w@rld!!!').for(:context) }

  describe 'scopes' do
    before do
      FactoryGirl.create_list(:review, 3, status: true)
      FactoryGirl.create_list(:review, 2, status: false)
    end

    context 'approved' do
      it 'finds approved reviews' do
        expect(Review.approved.map(&:status).sample).to be true
      end
    end
  end
end
