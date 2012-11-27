class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.belongs_to :question, null: false
      t.string :text, null: false

      t.timestamps null: false
    end
  end
end
