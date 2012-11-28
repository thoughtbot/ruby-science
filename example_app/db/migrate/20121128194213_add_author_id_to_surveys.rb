class AddAuthorIdToSurveys < ActiveRecord::Migration
  def up
    add_column :surveys, :author_id, :integer
    connection.update(<<-SQL)
      UPDATE surveys SET author_id = (SELECT id FROM users LIMIT 1)
    SQL
    change_column :surveys, :author_id, :integer, null: false
  end

  def down
    remove_column :surveys, :author_id
  end
end
