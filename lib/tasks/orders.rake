# frozen_string_literal: true

require 'csv'

namespace :orders do
  desc 'import orders'
  task :import, [:csv_file_path] => :environment do |_t, args|
    csv_file_path = args[:csv_file_path]
    orders_arr = []
    CSV.foreach(csv_file_path, headers: true, col_sep: ';') do |row|
      row_hash = row.to_h
      row_hash['commission'] = Order.calc_commission(amount: row_hash['amount'].to_f)
      orders_arr << row_hash
    end
    Order.upsert_all(orders_arr)
  end
end
