require "rails_helper"

RSpec.describe DispatchCampaignJob, type: :job do
  it "marks recipients as sent and completes the campaign" do
    allow(Kernel).to receive(:sleep)

    campaign = Campaign.create!(title: "Follow-up survey")
    campaign.recipients.create!(name: "Ada Lovelace", email: "ada@example.com")
    campaign.recipients.create!(name: "Grace Hopper", email: "grace@example.com")

    described_class.perform_now(campaign.id)

    expect(campaign.reload.status).to eq("completed")
    expect(campaign.recipients.pluck(:status).uniq).to eq([ "sent" ])
  end
end
