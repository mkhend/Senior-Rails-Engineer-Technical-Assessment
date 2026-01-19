class CreateRecipients < ActiveRecord::Migration[7.2]
  def change
    create_table :recipients do |t|
      t.references :campaign, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :status, null: false, default: "queued"

      t.timestamps
    end
  end
end
