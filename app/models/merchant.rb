# frozen_string_literal: true

class Merchant < ApplicationRecord
  include EmailValidatable

  has_many :orders, foreign_key: :merchant_reference, primary_key: :reference

  enum disbursement_frequencies: %i[DAILY WEEKLY]
  validates :disbursement_frequency, inclusion: { in: disbursement_frequencies }
end
