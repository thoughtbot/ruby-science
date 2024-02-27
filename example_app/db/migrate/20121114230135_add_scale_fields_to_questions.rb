class AddScaleFieldsToQuestions < ActiveRecord::Migration[4.2]
  def change
    add_column :questions, :minimum, :integer
    add_column :questions, :maximum, :integer
  end
end
