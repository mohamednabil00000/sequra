# frozen_string_literal: true

class AddIndexForCreatedAtInOrders < ActiveRecord::Migration[7.0]
  def change
    add_index :orders, :created_at
  end
end
