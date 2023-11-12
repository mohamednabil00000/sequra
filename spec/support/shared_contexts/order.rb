# frozen_string_literal: true

RSpec.shared_context 'group of orders' do
  let!(:order1) { create(:order, merchant_reference: merchant1.reference, id: '12') }
  let!(:order2) { create(:order, merchant_reference: merchant1.reference, id: '34') }
  let!(:order3) { create(:order, merchant_reference: merchant2.reference, id: '45') }
end
