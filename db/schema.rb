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

ActiveRecord::Schema[7.0].define(version: 20_231_111_221_128) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'

  create_table 'merchants', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'reference'
    t.string 'email'
    t.date 'live_on'
    t.string 'disbursement_frequency'
    t.float 'minimum_monthly_fee', default: 0.0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['reference'], name: 'index_merchants_on_reference', unique: true
  end

  create_table 'orders', id: :string, force: :cascade do |t|
    t.string 'merchant_reference'
    t.float 'amount', default: 0.0
    t.float 'commission', default: 0.0
    t.date 'created_at'
    t.datetime 'updated_at'
  end

  add_foreign_key 'orders', 'merchants', column: 'merchant_reference', primary_key: 'reference'
end
