class AddInvitationNotificationEnabledToUser < ActiveRecord::Migration
  def change
    add_column :users, :invitation_notification_enabled, :boolean, null: false, default: true
    add_column :users, :invitation_accept_notification_enabled, :boolean, null: false, default: true
  end
end
