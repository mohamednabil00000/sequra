# frozen_string_literal: true

class AddIndexForChargedMonthlyFeesForMerchantsMonthYear < ActiveRecord::Migration[7.0]
  def change
    add_index :charged_monthly_fees, %i[merchant_id month year], unique: true
  end
end
