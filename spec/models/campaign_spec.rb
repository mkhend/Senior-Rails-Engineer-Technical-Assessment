require "rails_helper"

RSpec.describe Campaign, type: :model do
  it "requires a title" do
    campaign = Campaign.new
    expect(campaign).not_to be_valid
    expect(campaign.errors[:title]).to include("can't be blank")
  end

  it "defaults to pending status" do
    campaign = Campaign.create!(title: "Test campaign")
    expect(campaign.status).to eq("pending")
  end
end
