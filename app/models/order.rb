# frozen_string_literal: true

class Order < ApplicationRecord
  include CalculateCommission

  belongs_to :merchant, foreign_key: :merchant_reference, primary_key: :reference
end
