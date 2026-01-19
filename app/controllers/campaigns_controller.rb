class CampaignsController < ApplicationController
  def index
    @campaign = Campaign.new
    @campaigns = Campaign.order(created_at: :desc)
  end

  def create
    @campaign = Campaign.new(campaign_params)
    @campaign.recipients_input = params.dig(:campaign, :recipients_input)
    recipients_attributes = parse_recipients(@campaign.recipients_input)

    if recipients_attributes.empty?
      @campaign.errors.add(:base, "Add at least one recipient.")
      return render_index_with_errors
    end

    recipients_attributes.each { |attrs| @campaign.recipients.build(attrs) }

    if @campaign.save
      DispatchCampaignJob.perform_later(@campaign.id)
      redirect_to @campaign, notice: "Campaign started. Dispatching recipients now."
    else
      render_index_with_errors
    end
  end

  def show
    @campaign = Campaign.includes(:recipients).find(params[:id])
  end

  def start_dispatch
    campaign = Campaign.find(params[:id])
    if campaign.pending?
      DispatchCampaignJob.perform_later(campaign.id)
      redirect_to campaign, notice: "Dispatch started."
    else
      redirect_to campaign, alert: "Campaign is already in progress or completed."
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title)
  end

  def parse_recipients(input)
    return [] if input.blank?

    input.lines.filter_map do |line|
      cleaned = line.strip
      next if cleaned.blank?

      name, email = parse_recipient_line(cleaned)
      next if name.blank? || email.blank?

      { name:, email: }
    end
  end

  def parse_recipient_line(line)
    if line.include?("<") && line.include?(">")
      name = line.split("<").first.to_s.strip
      email = line[/<(.*?)>/, 1].to_s.strip
      return [ name, email ]
    end

    parts = line.split(/,|;/).map(&:strip)
    [ parts[0], parts[1] ]
  end

  def render_index_with_errors
    @campaigns = Campaign.order(created_at: :desc)
    render :index, status: :unprocessable_entity
  end
end
