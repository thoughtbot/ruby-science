class AddScaleFieldsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :minimum, :integer
    add_column :questions, :maximum, :integer
  end
end
