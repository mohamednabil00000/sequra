# frozen_string_literal: true

class FeesService
  class << self
    def charging_minimum_monthly_fees_for_prev_month!
      charging_minimum_monthly_fees_for_given_month!(start_date: 1.month.ago.beginning_of_month,
                                                     end_date: 1.month.ago.end_of_month)
    end

    def charging_minimum_monthly_fees_for_given_month!(start_date:, end_date:)
      merchants_have_orders = Merchant.have_orders_of_given_month(start_date, end_date)
      merchants_ids = merchants_have_orders.pluck(:id)

      aggregate_fees_for_merchants_have_orders = merchants_have_orders.aggregate_fees
      persist_charged_minimum_fees!(
        charged_minimum_fees: aggregate_fees_for_merchants_have_orders,
        month: start_date.month, year: start_date.year
      )

      aggregate_fees_merchants_do_not_have_orders =
        Merchant.aggregate_fees_for_merchants_do_not_have_orders(merchants_ids)
      persist_charged_minimum_fees!(charged_minimum_fees: aggregate_fees_merchants_do_not_have_orders,
                                    month: start_date.month, year: start_date.year)
    end

    def update_minimum_fees_for_old_orders!(min_date:, max_date:)
      min_date = adjust_date(date: min_date)
      max_date = adjust_date(date: max_date)

      number_of_months = ((max_date.year * 12) + max_date.month) - ((min_date.year * 12) + min_date.month)
      (0..number_of_months).each do |count|
        charging_minimum_monthly_fees_for_given_month!(start_date: min_date + count.months,
                                                       end_date: min_date + (count + 1).months - 1)
      end
    end

    private

    def adjust_date(date:)
      date = [date, 1.month.ago].min # to not take the current month
      date.beginning_of_month
    end

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
