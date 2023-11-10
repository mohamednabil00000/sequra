# frozen_string_literal: true

class Merchant < ApplicationRecord
  include EmailValidatable

  enum disbursement_frequencies: %i[DAILY WEEKLY]
  validates :disbursement_frequency, inclusion: { in: disbursement_frequencies }
end
