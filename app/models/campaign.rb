class Campaign < ApplicationRecord
  has_many :recipients, dependent: :destroy

  accepts_nested_attributes_for :recipients, allow_destroy: true

  attr_accessor :recipients_input

  validates :title, presence: true

  enum :status, {
    pending: "pending",
    processing: "processing",
    completed: "completed"
  }, default: "pending"

  def progress_summary
    total = recipients.count
    sent = recipients.sent.count
    { sent:, total: }
  end
end
