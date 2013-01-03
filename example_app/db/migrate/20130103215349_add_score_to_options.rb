class AddScoreToOptions < ActiveRecord::Migration
  def change
    add_column :options, :score, :integer, null: false, default: 0
  end
end
