# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    id { Faker::String.random(length: 16) }
    merchant_reference { Faker::Internet.email }
    amount { 100 }
    commission { Order.calc_commission(amount:) }
  end
end
