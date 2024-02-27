class CreateMultipleChoiceSubmittables < ActiveRecord::Migration[4.2]
  def change
    create_table :multiple_choice_submittables do |table|
      table.timestamps null: false
    end
  end
end
