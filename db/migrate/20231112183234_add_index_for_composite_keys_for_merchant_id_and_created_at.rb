# frozen_string_literal: true

class AddIndexForCompositeKeysForMerchantIdAndCreatedAt < ActiveRecord::Migration[7.0]
  def change
    add_index :merchant_disbursements, %i[merchant_id created_at], unique: true
  end
end
