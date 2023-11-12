# frozen_string_literal: true

module CalculateCommission
  extend ActiveSupport::Concern

  COMMISSION_RATE = {
    high: 0.01,
    midium: 0.0095,
    low: 0.0085
  }.freeze

  class_methods do
    def calc_commission(amount:)
      commission = if amount < 50.0
                     amount * COMMISSION_RATE[:high]
                   elsif amount >= 50 && amount < 300
                     amount * COMMISSION_RATE[:midium]
                   elsif amount >= 300
                     amount * COMMISSION_RATE[:low]
                   end
      commission.round(2)
    end
  end
end
