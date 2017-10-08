# frozen_string_literal: true

shared_examples_for 'header and footer' do
  describe 'header' do
    subject { page.find('header') }
    header_content = ['Bookstore', 'Home', 'Shop', 'Log in', 'Sign up']

    header_content.each do |text|
      it { expect(subject).to have_content text }
    end
    it { expect(subject).not_to have_content 'Log out' }

    context 'Loged In user' do
      before { sign_in_as_user }
      it { expect(subject).to have_content 'Log out' }
      it { expect(subject).to have_content 'My account' }
      it { expect(subject).not_to have_content 'Log in' }
      it { expect(subject).not_to have_content 'Sign up' }
    end
  end

  describe 'footer' do
    subject { page.find('footer') }
    footer_content = ['Home', 'Shop', 'support@bookstore.com', '(555)-555-5555']

    footer_content.each do |text|
      it { expect(subject).to have_content text }
    end
    it { expect(subject).not_to have_content 'Orders' }
    it { expect(subject).not_to have_content 'Settings' }

    context 'Loged In user' do
      before { sign_in_as_user }
      it { expect(subject).to have_content 'Orders' }
      it { expect(subject).to have_content 'Settings' }
    end
  end
end
