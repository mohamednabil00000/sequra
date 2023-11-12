# frozen_string_literal: true

class Merchant < ApplicationRecord
  include EmailValidatable

  has_many :orders, foreign_key: :merchant_reference, primary_key: :reference
  has_many :merchant_disbursements

  enum disbursement_frequencies: %i[DAILY WEEKLY]
  validates :disbursement_frequency, inclusion: { in: disbursement_frequencies }

  scope :daily_merchants, -> { where(disbursement_frequency: :DAILY) }
  scope :weekly_merchants, -> { where(disbursement_frequency: :WEEKLY) }
  scope :same_weekday_as_live_on, -> { where(live_on_weekday: Date.today.strftime('%A')) }
  scope :aggregate_order_amounts_for_merchants,
        lambda {
          left_outer_joins(:orders)
            .group('merchants.id')
            .select('merchants.id as merchant_id, round(COALESCE(sum(orders.amount), 0)::numeric, 2) as disbursements')
        }
end
