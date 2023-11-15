# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
    it { should_not allow_value('test@test').for(:email).with_message('invalid format') }
    it { should allow_value('user@example.com').for(:email) }
    it { should validate_inclusion_of(:disbursement_frequency).in_array(%i[DAILY WEEKLY]) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:orders).with_foreign_key(:merchant_reference).with_primary_key(:reference) }
    it { is_expected.to have_many(:merchant_disbursements) }
    it { is_expected.to have_many(:charged_monthly_fees) }
  end

  describe 'scopes' do
    include_context 'group of merchants'

    describe '#daily_merchants' do
      it 'returns first and second merchants' do
        expect(described_class.daily_merchants.pluck(:email)).to match_array [merchant1.email, merchant2.email]
      end
    end

    describe '#weekly_merchants' do
      it 'returns third merchant' do
        expect(described_class.weekly_merchants.pluck(:email)).to match_array [merchant3.email]
      end
    end

    describe '#same_weekday_as_live_on' do
      it 'returns first merchant' do
        expect(described_class.same_weekday_as_live_on.pluck(:email)).to match_array [merchant1.email]
      end
    end

    describe '#aggregate_order_amounts_for_merchants' do
      include_context 'group of orders'

      it 'returns sum of amount grouping by merchants' do
        result = described_class.aggregate_order_amounts_for_merchants
        merchants_disbursements_arr = result.map { |row| row.slice(:merchant_id, :disbursements) }
        expect(merchants_disbursements_arr).to match_array([
                                                             { merchant_id: merchant1.id, disbursements: 200.0 },
                                                             { merchant_id: merchant2.id, disbursements: 100.0 },
                                                             { merchant_id: merchant3.id, disbursements: 0 }
                                                           ])
      end
    end

    describe '#orders_of_given_month' do
      include_context 'group of orders in prev month'

      it 'returns three orders' do
        result = described_class.have_orders_of_given_month(Time.now.beginning_of_month - 1.month,
                                                            Time.now.beginning_of_month - 1)
        expect(result.size).to eq 3
        expect(result.pluck('orders.id')).to match_array [order1.id, order2.id, order3.id]
      end
    end

    describe '#aggregate_fees' do
      include_context 'group of orders in prev month'

      it 'returns first merchant' do
        result = described_class.have_orders_of_given_month(Time.now.beginning_of_month - 1.month,
                                                            Time.now.beginning_of_month - 1).aggregate_fees
        charged_fees_arr = result.map { |row| row.slice(:merchant_id, :amount_charged) }
        expect(charged_fees_arr).to match_array([
                                                  { merchant_id: merchant1.id, amount_charged: 300.0 }
                                                ])
      end
    end

    describe '#aggregate_fees_for_merchants_do_not_have_orders' do
      include_context 'group of orders in prev month'

      it 'returns third merchant' do
        merchants_have_orders = described_class.have_orders_of_given_month(Time.now.beginning_of_month - 1.month,
                                                                           Time.now.beginning_of_month - 1)
        merchants_ids = merchants_have_orders.pluck(:id)
        result = described_class.aggregate_fees_for_merchants_do_not_have_orders(merchants_ids)
        charged_fees_arr = result.map { |row| row.slice(:merchant_id, :amount_charged) }
        expect(charged_fees_arr).to match_array([
                                                  { merchant_id: merchant3.id, amount_charged: 200.0 }
                                                ])
      end
    end
  end
end
