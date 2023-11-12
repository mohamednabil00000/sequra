# frozen_string_literal: true

class MerchantDisbursement < ApplicationRecord
  belongs_to :merchant

  validates :merchant_id, presence: true, uniqueness: { scope: :created_at }
end
