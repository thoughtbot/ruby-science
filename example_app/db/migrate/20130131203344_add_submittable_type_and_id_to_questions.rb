class AddSubmittableTypeAndIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :submittable_id, :integer
    add_column :questions, :submittable_type, :string
  end
end
