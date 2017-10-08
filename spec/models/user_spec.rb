# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { expect(subject).to validate_uniqueness_of(:email).case_insensitive }
  it { expect(subject).to validate_presence_of :email }
  it { expect(subject).to have_one :billing }
  it { expect(subject).to have_one :shipping }
  it { expect(subject).to have_many :reviews }
  it { expect(subject).to have_many :addresses }

  it { expect(subject).to allow_value('example@example.com').for(:email) }
  it { expect(subject).to allow_value('my-example.example@example.net').for(:email) }
  it { expect(subject).to allow_value('!@#$%^&*()1Fa').for(:password) }
  it { expect(subject).to allow_value('123456Ab').for(:password) }
  it { expect(subject).not_to allow_value('exam..ple@example.com').for(:email) }
  it { expect(subject).not_to allow_value('-example.example@example.net').for(:email) }
  it { expect(subject).not_to allow_value('example-@example.net').for(:email) }
  it { expect(subject).not_to allow_value('123!@#$KH12F').for(:password) }
  it { expect(subject).not_to allow_value('123 gfdf FF !@#').for(:password) }
end
