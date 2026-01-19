require "rails_helper"

RSpec.describe Recipient, type: :model do
  it "requires a name and email" do
    campaign = Campaign.create!(title: "Test campaign")
    recipient = campaign.recipients.build

    expect(recipient).not_to be_valid
    expect(recipient.errors[:name]).to include("can't be blank")
    expect(recipient.errors[:email]).to include("can't be blank")
  end

  it "defaults to queued status" do
    campaign = Campaign.create!(title: "Test campaign")
    recipient = campaign.recipients.create!(name: "Ada", email: "ada@example.com")
    expect(recipient.status).to eq("queued")
  end
end
