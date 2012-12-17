class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :sender
      t.references :survey
      t.string :recipient_email
      t.string :status, default: 'pending'
      t.string :token
      t.timestamps
    end

    add_index :invitations, :survey_id
    add_index :invitations, :token, unique: true
  end
end
