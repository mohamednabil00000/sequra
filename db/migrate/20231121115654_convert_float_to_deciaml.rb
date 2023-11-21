# frozen_string_literal: true

class ConvertFloatToDeciaml < ActiveRecord::Migration[7.0]
  def change
    change_column(:merchant_disbursements, :disbursements, :decimal)
    change_column(:charged_monthly_fees, :amount_charged, :decimal)
    change_column(:orders, :amount, :decimal)
    change_column(:orders, :commission, :decimal)
  end
end
