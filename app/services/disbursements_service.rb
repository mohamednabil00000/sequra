# frozen_string_literal: true

class DisbursementsService
  class << self
    def calc_disbursements_for_merchants!
      calc_daily_disbursements!
      calc_weekly_disbursements!
    end

    private

    def calc_daily_disbursements!
      merchants_disbursements = Merchant.daily_merchants.aggregate_order_amounts_for_merchants
      persist_merchants!(merchants_disbursements:) unless merchants_disbursements.empty?
    end

    def calc_weekly_disbursements!
      merchants_disbursements = Merchant.weekly_merchants.same_weekday_as_live_on.aggregate_order_amounts_for_merchants
      persist_merchants!(merchants_disbursements:) unless merchants_disbursements.empty?
    end

    def persist_merchants!(merchants_disbursements:)
      merchants_disbursements_arr = merchants_disbursements.map { |row| row.slice(:merchant_id, :disbursements) }
      MerchantDisbursement.upsert_all(merchants_disbursements_arr, unique_by: %i[merchant_id created_at])
    end
  end
end
