# frozen_string_literal: true

class CreateMerchantDisbursements < ActiveRecord::Migration[7.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

  def change
    create_table :merchant_disbursements, id: :bigint do |t|
      t.references :merchant, type: :uuid, index: { name: 'merchant_index_1' }
      t.float :disbursements, default: 0
      t.date :created_at
      t.datetime :updated_at
    end
  end
end
