# frozen_string_literal: true

set :output, '/logs/cron_log.log'

every :day, at: '08:00am' do
  rake 'merchants:disbursements_calculations'
end
