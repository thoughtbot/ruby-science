class AddSubmittableTypeAndIdToQuestions < ActiveRecord::Migration[4.2]
  def change
    add_column :questions, :submittable_id, :integer
    add_column :questions, :submittable_type, :string
  end
end
