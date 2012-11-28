class RenameSubmittableTypeToQuestionType < ActiveRecord::Migration
  def up
    rename_column :questions, :submittable_type, :question_type
  end

  def down
    rename_column :questions, :question_type, :submittable_type
  end
end
