class CreateUnsubscribes < ActiveRecord::Migration[4.2]
  def up
    create_table :unsubscribes do |t|
      t.string :email, null: false

      t.timestamps null: false
    end

    add_index :unsubscribes, :email
  end

  def down
    drop_table :unsubscribes
  end
end
