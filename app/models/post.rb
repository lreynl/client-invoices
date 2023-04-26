class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  
  enum status: { created: 0, rejected: 1, approved: 2, purchased: 3, closed: 4 }

  validate :valid_status_transition, on: :update

  private

  def valid_status_transition
    if status_was
      if ['rejected', 'closed'].include? status_was
        errors.add(:status, "'#{status_was}' status cannot be changed")
      elsif status_was != status && Post.statuses[status] < Post.statuses[status_was]
        errors.add(:status, "Current status '#{status_was}' cannot be changed back to '#{status}'")
      end
    end
  end
end
