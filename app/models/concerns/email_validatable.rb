# frozen_string_literal: true

module EmailValidatable
  extend ActiveSupport::Concern

  included do
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: /\A.+@.+\.\w{2,6}\Z/, message: I18n.t('errors.messages.invalid_format') },
                      if: :email_required?

    private

    def email_required?
      email.present?
    end
  end
end
