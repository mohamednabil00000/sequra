# frozen_string_literal: true

require 'rails_helper'

describe 'rake merchants:import', type: :task do
  it 'import merchants' do
    expect do
      task.invoke('csv_files/merchants.csv')
    end.to change { Merchant.count }.by(50)
  end
end
