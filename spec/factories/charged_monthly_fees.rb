# frozen_string_literal: true

FactoryBot.define do
  factory :charged_monthly_fee do
    merchant
    amount_charged { 0 }
  end
end
