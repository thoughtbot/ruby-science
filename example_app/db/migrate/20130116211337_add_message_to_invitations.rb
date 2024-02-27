class AddMessageToInvitations < ActiveRecord::Migration[4.2]
  def change
    add_column :invitations, :message, :text, null: false, default: ''
  end
end
