class Post < ApplicationRecord
  # belongs_to :user
  enum status: { draft: 0, rejected: 1, review: 2, published: 3 }

  has_one_attached :file

  # validate :status_cannot_be_changed_back
  validate :valid_status_transition, on: :update

  private

  def valid_status_transition
    # if status_changed? && !Post.statuses.key?(status_was.to_sym)
    #   errors.add(:status, "#{status_was} is not a valid status")
    # els
    #puts ["* " + status_was, status, body]
    if status_was
      if status_changed? && status_was == 'rejected'
        errors.add(:status, "#{status_was} status cannot be changed")
      elsif status_was != status && Post.statuses[status] < Post.statuses[status_was]
        errors.add(:status, "Current status '#{status_was}' cannot be changed back to '#{status}'")
      end
    end
  end
  # def status_cannot_be_changed_back
  #   if status == 'rejected'
  #     errors.add(:status, "#{status_was} status cannot be changed")
  #   end
  #   if status_changed? && status_was.present? && status_was != status && Request.statuses[status_was] < Request.statuses[status]
  #     errors.add(:status, "cannot be changed back to #{status_was}")
  #   end
  # end
end
