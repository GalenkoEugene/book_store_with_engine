# frozen_string_literal: true

require 'rails_helper'
RSpec.describe HomeHelper, type: :helper do
  describe '#log_out_helper' do
    it 'returns log out html' do
      expect(helper.log_out_helper).to match /href=\"\/users\/sign_out\">Log out/
    end
  end

  describe '#active' do
    it 'return string active for zero index' do
      index = 0
      expect(helper.active(index)).to eq 'active'
    end

    (1..6).to_a.each do |index|
      it "return false or nil for all except zero index e.g.#{index}" do
        expect(helper.active(index)).to be_falsey
      end
    end
  end
end
