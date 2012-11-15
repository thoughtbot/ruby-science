class CreateCompletions < ActiveRecord::Migration
  def change
    create_table :completions do |t|
      t.belongs_to :survey, null: false
      t.belongs_to :user, null: false

      t.timestamps
    end
    add_index :completions, :survey_id
    add_index :completions, :user_id
  end
end
