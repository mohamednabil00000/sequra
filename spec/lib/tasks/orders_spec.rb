# frozen_string_literal: true

require 'rails_helper'

describe 'rake orders:import', type: :task do
  describe '#import' do
    context 'when merchant reference exists' do
      let!(:merchant) { create(:merchant, reference: 'padberg_group', email: 'test@gmail.com') }
      it '2 orders should be imported' do
        expect do
          task.invoke('csv_files/orders_sample.csv')
        end.to change { Order.count }.by(2)
        expect(Order.pluck(:commission)).to match_array([0.97, 3.68])
      end
    end

    context 'when merchant reference does not exist' do
      it '2 orders should be imported' do
        expect do
          task.invoke('csv_files/orders_sample.csv')
        end.not_to(change { Order.count })
      end
    end
  end
end
