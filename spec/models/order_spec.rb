# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:merchant).with_foreign_key(:merchant_reference).with_primary_key(:reference) }
  end

  describe 'class methods' do
    describe '#calc_commission' do
      it_behaves_like 'calculate commission'
    end
  end
end
