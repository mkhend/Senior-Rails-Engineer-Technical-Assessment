require "rails_helper"

RSpec.describe "Campaigns", type: :request do
  include ActiveJob::TestHelper

  it "creates a campaign with recipients and enqueues a dispatch job" do
    clear_enqueued_jobs
    recipients_input = <<~TEXT
      Ada Lovelace, ada@example.com
      Grace Hopper <grace@example.com>
    TEXT

    expect do
      post campaigns_path, params: {
        campaign: {
          title: "Post-purchase review request",
          recipients_input: recipients_input
        }
      }
    end.to change(Campaign, :count).by(1)
      .and change(Recipient, :count).by(2)

    campaign = Campaign.last
    expect(DispatchCampaignJob).to have_been_enqueued.with(campaign.id)
    expect(response).to redirect_to(campaign_path(campaign))
  end
end

