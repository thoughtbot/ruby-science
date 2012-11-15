class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :completion, null: false
      t.belongs_to :question, null: false
      t.string :text, null: false

      t.timestamps null: false
    end
    add_index :answers, :completion_id
    add_index :answers, :question_id
  end
end
