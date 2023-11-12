# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MerchantDisbursement, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :merchant_id }
    it { is_expected.to validate_uniqueness_of(:merchant_id).ignoring_case_sensitivity.scoped_to(:created_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:merchant) }
  end
end
