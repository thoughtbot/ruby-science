class CreateScaleSubmittables < ActiveRecord::Migration
  def change
    create_table :scale_submittables do |table|
      table.timestamps null: false
    end
  end
end
