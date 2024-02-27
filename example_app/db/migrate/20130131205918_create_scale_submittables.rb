class CreateScaleSubmittables < ActiveRecord::Migration[4.2]
  def change
    create_table :scale_submittables do |table|
      table.timestamps null: false
    end
  end
end
