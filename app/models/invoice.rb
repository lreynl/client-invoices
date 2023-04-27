class Invoice < ApplicationRecord
  belongs_to :client
  has_one_attached :file
  
  enum status: { created: 0, rejected: 1, approved: 2, purchased: 3, closed: 4 }

  validate :valid_status_transition, on: :update
  validate :non_negative_amount
  monetize :invoice_amount_cents
  before_save :set_purchased_date, if: :purchased?

  private

  def valid_status_transition
    if status_was
      if ['rejected', 'closed'].include? status_was
        errors.add(:status, "'#{status_was}' status cannot be changed")
      elsif status_was != status && Invoice.statuses[status] < Invoice.statuses[status_was]
        errors.add(:status, "Current status '#{status_was}' cannot be changed back to '#{status}'")
      end
    end
  end

  def non_negative_amount
    if invoice_amount_cents < 0
      errors.add(:invoice_amount_cents, "Cannot send a negative amount :^)")
    end
  end

  def set_purchased_date
    self.purchase_date ||= Time.current
  end
end
