# frozen_string_literal: true

class CreateChargedMonthlyFees < ActiveRecord::Migration[7.0]
  def change
    create_table :charged_monthly_fees do |t|
      t.references :merchant, type: :uuid, index: { name: 'merchant_index_2' }
      t.float :amount_charged, default: 0.0
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
