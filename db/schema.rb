# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_231_113_144_924) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'

  create_table 'charged_monthly_fees', force: :cascade do |t|
    t.uuid 'merchant_id'
    t.float 'amount_charged', default: 0.0
    t.integer 'month'
    t.integer 'year'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[merchant_id month year], name: 'index_charged_monthly_fees_on_merchant_id_and_month_and_year',
                                        unique: true
    t.index ['merchant_id'], name: 'merchant_index_2'
  end

  create_table 'merchant_disbursements', force: :cascade do |t|
    t.uuid 'merchant_id'
    t.float 'disbursements', default: 0.0
    t.date 'created_at'
    t.datetime 'updated_at'
    t.index %w[merchant_id created_at], name: 'index_merchant_disbursements_on_merchant_id_and_created_at',
                                        unique: true
    t.index ['merchant_id'], name: 'merchant_index_1'
  end

  create_table 'merchants', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'reference'
    t.string 'email'
    t.date 'live_on'
    t.string 'disbursement_frequency'
    t.float 'minimum_monthly_fee', default: 0.0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'live_on_weekday'
    t.index ['reference'], name: 'index_merchants_on_reference', unique: true
  end

  create_table 'orders', id: :string, force: :cascade do |t|
    t.string 'merchant_reference'
    t.float 'amount', default: 0.0
    t.float 'commission', default: 0.0
    t.date 'created_at'
    t.datetime 'updated_at'
    t.index ['created_at'], name: 'index_orders_on_created_at'
    t.index ['merchant_reference'], name: 'index_orders_on_merchant_reference'
  end

  add_foreign_key 'orders', 'merchants', column: 'merchant_reference', primary_key: 'reference'
end
