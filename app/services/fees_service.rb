# frozen_string_literal: true

class FeesService
  class << self
    def charging_minimum_monthly_fees_for_prev_month!
      merchants_have_orders = Merchant.have_orders_of_prev_month
      merchants_ids = merchants_have_orders.pluck(:id)

      aggregate_fees_for_merchants_have_orders = merchants_have_orders.aggregate_fees
      persist_charged_minimum_fees!(
        charged_minimum_fees: aggregate_fees_for_merchants_have_orders,
        month: 1.month.ago.month, year: 1.month.ago.year
      )

      aggregate_fees_merchants_do_not_have_orders =
        Merchant.aggregate_fees_for_merchants_do_not_have_orders_prev_month(merchants_ids)
      persist_charged_minimum_fees!(charged_minimum_fees: aggregate_fees_merchants_do_not_have_orders,
                                    month: 1.month.ago.month, year: 1.month.ago.year)
    end

    private

    def persist_charged_minimum_fees!(charged_minimum_fees:, month:, year:)
      return if charged_minimum_fees.empty?

      charged_fees_for_merchants = charged_minimum_fees.map do |row|
        row_json = row.as_json.slice('merchant_id', 'amount_charged')
        row_json['month'] = month
        row_json['year'] = year
        row_json
      end
      ChargedMonthlyFee.upsert_all(charged_fees_for_merchants, unique_by: %i[merchant_id month year])
    end
  end
end
