# frozen_string_literal: true

set :output, '/logs/cron_log.log'

every :day, at: '08:00am' do
  rake 'merchants:disbursements_calculations'
end

every '0 0 1 * *' do
  rake 'merchants:minimum_monthly_fees_calculations'
end
