# frozen_string_literal: true

class AddIndexForReference < ActiveRecord::Migration[7.0]
  def change
    add_index :orders, :merchant_reference
  end
end
