# frozen_string_literal: true

class AddWeekdayColumnIntoMerchants < ActiveRecord::Migration[7.0]
  def change
    add_column :merchants, :live_on_weekday, :string
  end
end
