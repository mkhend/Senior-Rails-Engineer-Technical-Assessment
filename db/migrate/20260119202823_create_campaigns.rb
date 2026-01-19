class CreateCampaigns < ActiveRecord::Migration[7.2]
  def change
    create_table :campaigns do |t|
      t.string :title, null: false
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end
