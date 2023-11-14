# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeesService do
  include_context 'group of merchants'
  let(:subject) { described_class }

  describe '#charging_minimum_monthly_fees_for_prev_month!' do
    context 'when we have records in prev month' do
      context 'persist minimum monthly fees for merchants has less than minimum fees' do
        include_context 'group of orders in prev month'

        it 'persist first and third merchants' do
          expect do
            subject.charging_minimum_monthly_fees_for_prev_month!
          end.to change { ChargedMonthlyFee.count }.by(2)
          charged_monthly_fees = ChargedMonthlyFee.all
          expect(charged_monthly_fees.pluck(:merchant_id,
                                            :amount_charged)).to match_array [[merchant1.id, 300],
                                                                              [merchant3.id, 200]]
        end
      end
    end

    context 'when we do not have orders in prev month' do
      include_context 'group of orders'

      it 'persist all merchants with their minimum fees' do
        expect do
          subject.charging_minimum_monthly_fees_for_prev_month!
        end.to change { ChargedMonthlyFee.count }.by(3)
        charged_monthly_fees = ChargedMonthlyFee.all
        expect(charged_monthly_fees.pluck(:merchant_id,
                                          :amount_charged)).to match_array [[merchant1.id, 500], [merchant3.id, 200],
                                                                            [merchant2.id, 100]]
      end
    end
  end

  describe '#charging_minimum_monthly_fees_for_given_month' do
    include_context 'group of orders in 2 months ago'

    it 'persist first merchant' do
      expect do
        subject.charging_minimum_monthly_fees_for_given_month!(start_date: 2.months.ago.beginning_of_month,
                                                               end_date: 2.months.ago.end_of_month)
      end.to change { ChargedMonthlyFee.count }.by(1)
      charged_monthly_fees = ChargedMonthlyFee.all
      expect(charged_monthly_fees.pluck(:merchant_id,
                                        :amount_charged)).to match_array [[merchant1.id, 400]]
    end
  end
end
