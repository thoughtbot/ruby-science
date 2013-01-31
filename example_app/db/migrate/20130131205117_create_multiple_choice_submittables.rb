class CreateMultipleChoiceSubmittables < ActiveRecord::Migration
  def change
    create_table :multiple_choice_submittables do |table|
      table.timestamps null: false
    end
  end
end
