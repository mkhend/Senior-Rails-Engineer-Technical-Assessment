class Recipient < ApplicationRecord
  belongs_to :campaign

  validates :name, :email, presence: true

  enum :status, {
    queued: "queued",
    sent: "sent",
    failed: "failed"
  }, default: "queued"
end
