class RenameQuestionTypeToType < ActiveRecord::Migration[4.2]
  def up
    rename_column :questions, :question_type, :type
  end

  def down
    rename_column :questions, :type, :question_type
  end
end
