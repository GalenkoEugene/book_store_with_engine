require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryGirl.create(:user, email: 'lucas@email.com') }

  describe 'instructions' do
    let(:mail) { described_class.confirm_account(user.email, user.password).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq I18n.t('mailer.subject')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['galenko@bookstore.com'])
    end
  end
end
