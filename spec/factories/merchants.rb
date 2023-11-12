# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    email { Faker::Internet.email }
    reference { Faker::String.random(length: 16) }
    live_on { Date.current }
    disbursement_frequency { :DAILY }
  end
end
