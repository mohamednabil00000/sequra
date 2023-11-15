# frozen_string_literal: true

FactoryBot.define do
  factory :merchant_disbursement do
    merchant
    disbursements { 0 }
  end
end
