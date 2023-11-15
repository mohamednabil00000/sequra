# frozen_string_literal: true

class CreateMerchants < ActiveRecord::Migration[7.0]
  enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

  def change
    create_table :merchants, id: :uuid do |t|
      t.string :reference
      t.string :email
      t.date :live_on
      t.string :disbursement_frequency
      t.float :minimum_monthly_fee, default: 0.0

      t.timestamps
    end
  end
end
