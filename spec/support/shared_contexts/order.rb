# frozen_string_literal: true

RSpec.shared_context 'group of orders' do
  let!(:order1) { create(:order, merchant_reference: merchant1.reference, id: '12') }
  let!(:order2) { create(:order, merchant_reference: merchant1.reference, id: '34') }
  let!(:order3) { create(:order, merchant_reference: merchant2.reference, id: '45') }
end

RSpec.shared_context 'group of orders in prev month' do
  let!(:order1) do
    create(:order, merchant_reference: merchant1.reference, id: '12', amount: 10_000.0, commission: 100.0,
                   created_at: 1.month.ago)
  end
  let!(:order2) do
    create(:order, merchant_reference: merchant1.reference, id: '34', amount: 10_000.0, commission: 100.0,
                   created_at: 1.month.ago)
  end
  let!(:order3) do
    create(:order, merchant_reference: merchant2.reference, id: '45', amount: 10_000.0, commission: 100.0,
                   created_at: 1.month.ago)
  end
  let!(:order4) do
    create(:order, merchant_reference: merchant3.reference, id: '47', amount: 10_000.0, commission: 500.0,
                   created_at: Date.current)
  end
end
