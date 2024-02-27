class AddScoreToOptions < ActiveRecord::Migration[4.2]
  def change
    add_column :options, :score, :integer, null: false, default: 0
  end
end
