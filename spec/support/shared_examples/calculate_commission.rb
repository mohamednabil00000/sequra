# frozen_string_literal: true

RSpec.shared_examples 'calculate commission' do
  it 'when the amount is less than 50' do
    expect(described_class.calc_commission(amount: 49)).to eq 0.49
  end

  it 'when the amount is greate than or equal 50 and less than 300' do
    expect(described_class.calc_commission(amount: 50)).to eq 0.48
  end
  it 'when the amount is greate than or equal 300' do
    expect(described_class.calc_commission(amount: 300)).to eq 2.55
  end
end
