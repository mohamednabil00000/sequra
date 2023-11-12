# frozen_string_literal: true

require 'rails_helper'

describe 'rake merchants:import', type: :task do
  it 'import merchants' do
    expect do
      task.invoke('csv_files/merchants.csv')
    end.to change { Merchant.count }.by(50)
  end
end

describe 'rake merchants:disbursements_calculations', type: :task do
  context 'when we have records' do
    include_context 'group of merchants'
    include_context 'group of orders'

    it 'disbursements calculations for merchants' do
      expect do
        task.invoke
      end.to change { MerchantDisbursement.count }.by(2)

      merchant_disbursements = MerchantDisbursement.all
      expect(merchant_disbursements.pluck(:merchant_id)).to match_array [merchant1.id, merchant2.id]
      expect(merchant_disbursements.pluck(:disbursements)).to match_array [200.0, 100.0]
    end
  end

  context 'when we do not have records' do
    it 'disbursements calculations for merchants' do
      expect do
        task.invoke
      end.not_to(change { MerchantDisbursement.count })
    end
  end
end
