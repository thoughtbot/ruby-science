class AddMessageToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :message, :text, null: false, default: ''
  end
end
