require "rails_helper"

RSpec.describe "Campaign dispatch", type: :system do
  include ActiveJob::TestHelper

  it "updates the UI as recipients are dispatched" do
    allow(Kernel).to receive(:sleep)

    campaign = Campaign.create!(title: "Feedback follow-up")
    campaign.recipients.create!(name: "Ada Lovelace", email: "ada@example.com")
    campaign.recipients.create!(name: "Grace Hopper", email: "grace@example.com")

    visit campaign_path(campaign)
    expect(page).to have_content("Queued")

    perform_enqueued_jobs do
      click_button "Start dispatch"
    end

    expect(page).to have_content("Sent", wait: 5)
    expect(page).to have_content("Sent 2 of 2", wait: 5)
  end
end

