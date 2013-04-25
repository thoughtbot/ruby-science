class CreateUnsubscribes < ActiveRecord::Migration
  def change
    create_table :unsubscribes do |t|
      t.string :email, null: false

      t.timestamps null: false
    end
  end
end
