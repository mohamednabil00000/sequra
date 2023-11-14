# frozen_string_literal: true

class Merchant < ApplicationRecord
  include EmailValidatable

  has_many :orders, foreign_key: :merchant_reference, primary_key: :reference
  has_many :merchant_disbursements
  has_many :charged_monthly_fees

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
  scope :have_orders_of_prev_month,
        lambda {
          left_outer_joins(:orders).where('orders.created_at BETWEEN ? AND ?',
                                          Time.now.beginning_of_month - 1.month, Time.now.beginning_of_month)
        }

  scope :aggregate_fees_for_merchants_do_not_have_orders_prev_month,
        lambda { |merchants_ids|
          where.not(id: merchants_ids).select('id as merchant_id, minimum_monthly_fee as amount_charged')
        }

  scope :aggregate_fees,
        lambda {
          group('merchants.id')
            .having('round(COALESCE(sum(orders.commission), 0)::numeric, 2) < merchants.minimum_monthly_fee')
            .select(
              'merchants.id as merchant_id,' \
              '(merchants.minimum_monthly_fee - round(COALESCE(sum(orders.commission), 0)::numeric, 2))' \
              'as amount_charged'
            )
        }
end
