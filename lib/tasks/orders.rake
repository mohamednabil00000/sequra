# frozen_string_literal: true

require 'csv'

namespace :orders do
  desc 'import orders'
  task :import, [:csv_file_path] => :environment do |_t, args|
    csv_file_path = args[:csv_file_path]
    orders_arr = []
    @min_date = Time.current
    @max_date = 20.years.ago
    CSV.foreach(csv_file_path, headers: true, col_sep: ';') do |row|
      row_hash = row.to_h
      min_max_date(date: Date.parse(row_hash['created_at']))
      row_hash['commission'] = Order.calc_commission(amount: row_hash['amount'].to_f)
      orders_arr << row_hash
    end
    Order.upsert_all(orders_arr)
    FeesService.update_minimum_fees_for_old_orders!(min_date: @min_date, max_date: @max_date)
  end

  private

  def min_max_date(date:)
    @min_date = [@min_date, date].min
    @max_date = [@max_date, date].max
  end
end
