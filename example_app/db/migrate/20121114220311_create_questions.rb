class CreateQuestions < ActiveRecord::Migration[4.2]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.string :submittable_type, null: false
      t.belongs_to :survey, null: false

      t.timestamps null: false
    end
  end
end
