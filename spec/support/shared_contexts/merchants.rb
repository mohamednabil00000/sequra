# frozen_string_literal: true

RSpec.shared_context 'group of merchants' do
  let!(:merchant1) do
    create(:merchant, email: 'test@gmail.com', reference: 'ref', created_at: 1.week.ago,
                      live_on_weekday: Date.today.strftime('%A'))
  end
  let!(:merchant2) do
    create(:merchant, email: 'test2@gmail.com', reference: 'ref2', created_at: 1.day.ago,
                      live_on_weekday: 1.day.ago.strftime('%A'))
  end
  let!(:merchant3) do
    create(:merchant, email: 'test3@gmail.com',
                      disbursement_frequency: :WEEKLY, reference: 'ref3', created_at: 1.day.ago,
                      live_on_weekday: 1.day.ago.strftime('%A'))
  end
end
