# frozen_string_literal: true

require 'csv'

namespace :merchants do
  desc 'import merchants'
  task :import, [:csv_file_path] => :environment do |_t, args|
    csv_file_path = args[:csv_file_path]
    merchants_arr = []
    CSV.foreach(csv_file_path, headers: true, col_sep: ';') do |row|
      row_hash = row.to_h
      row_hash['live_on_weekday'] = Date.parse(row_hash['live_on']).strftime('%A')
      merchants_arr << row_hash
    end
    Merchant.upsert_all(merchants_arr)
  end

  desc 'disbursements calculations for merchants either daily or weekly'
  task disbursements_calculations: :environment do
    DisbursementsService.new.calc_disbursements_for_merchants!
  end
end
