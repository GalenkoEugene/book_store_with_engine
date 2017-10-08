# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewDecorator do
  describe '#created_at' do
    it 'format time for review' do
      review = FactoryGirl.create(:review, created_at: '2017-08-06 12:00:00').decorate
      expect(review.created_at).to eq '08/06/17'
    end
  end

  describe '#book_score' do
    (1..5).each do |star|
      it "show #{star} #{'star'. pluralize(star)} when score is #{star}" do
        review = FactoryGirl.create(:review, score: star).decorate
        expect(review.book_score.scan(%r{rate-star\'><\/i>}).size).to eq star
      end
    end
  end

  describe '#book_score' do
    stars = [[1, 4], [2, 3], [3, 2], [4, 1]]
    stars.each do |star|
      it "hide #{star.first} #{'star'. pluralize(star[0])} when score is #{star[1]}" do
        review = FactoryGirl.create(:review, score: star[0]).decorate
        expect(review.book_score.scan(/rate-empty/).size).to eq star[1]
      end
    end
  end

  describe '#user_avatar' do
    subject { review.user_avatar }
    let(:review) { FactoryGirl.build_stubbed(:review).decorate }
    before do
      allow_any_instance_of(Review)
        .to receive_message_chain('user.email') { 'example@mail.com' }
      allow_any_instance_of(Review)
        .to receive_message_chain('user.image') { nil }
    end

    it 'show first letter for e-mail' do
      expect(subject).to include("logo-empty'>E</span>")
    end

    it 'do not show user avatar' do
      expect(subject).not_to include("img class='img-circle")
      expect(subject).not_to include('http://')
    end

    it 'show user avatar' do
      allow_any_instance_of(Review)
        .to receive_message_chain('user.image') { 'http://image_url' }
      expect(subject).to include("img class='img-circle")
      expect(subject).to include('http://image_url')
    end
  end
end
