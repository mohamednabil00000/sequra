# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders, id: :string do |t|
      t.string :merchant_reference
      t.float :amount, default: 0.0
      t.float :commission, default: 0.0
      t.date :created_at
      t.datetime :updated_at
    end
    add_foreign_key :orders, :merchants, column: :merchant_reference, primary_key: :reference
  end
end
