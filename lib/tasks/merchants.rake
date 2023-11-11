# frozen_string_literal: true

require 'csv'

namespace :merchants do
  desc 'import merchants'
  task :import, [:csv_file_path] => :environment do |_t, args|
    csv_file_path = args[:csv_file_path]
    merchants_arr = []
    CSV.foreach(csv_file_path, headers: true, col_sep: ';') { |row| merchants_arr << row.to_h }
    Merchant.upsert_all(merchants_arr)
  end
end
