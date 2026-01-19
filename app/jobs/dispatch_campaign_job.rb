class DispatchCampaignJob < ApplicationJob
  queue_as :default

  include ActionView::RecordIdentifier

  def perform(campaign_id)
    campaign = Campaign.find(campaign_id)
    campaign.update!(status: :processing)
    broadcast_progress(campaign)

    campaign.recipients.find_each do |recipient|
      begin
        sleep(rand(1..3))
        recipient.update!(status: :sent)
      rescue StandardError
        recipient.update!(status: :failed)
      ensure
        broadcast_recipient(recipient, campaign)
        broadcast_progress(campaign)
      end
    end

    campaign.update!(status: :completed)
    broadcast_progress(campaign)
  end

  private

  def broadcast_recipient(recipient, campaign)
    recipient.broadcast_replace_to(
      campaign,
      target: dom_id(recipient),
      partial: "recipients/recipient",
      locals: { recipient: recipient }
    )
  end

  def broadcast_progress(campaign)
    campaign.broadcast_replace_to(
      campaign,
      target: "campaign_progress",
      partial: "campaigns/progress",
      locals: { campaign: campaign }
    )
  end
end

