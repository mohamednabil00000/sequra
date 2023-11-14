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
  it 'expect receiving calc disbursements for merchants method' do
    expect(DisbursementsService).to receive(:calc_disbursements_for_merchants!).once
    task.invoke
  end
end

describe 'rake merchants:minimum_monthly_fees_calculations', type: :task do
  it 'expect receiving charging_minimum_monthly_fees_for_prev_month method' do
    expect(FeesService).to receive(:charging_minimum_monthly_fees_for_prev_month!).once
    task.invoke
  end
end
