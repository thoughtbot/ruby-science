class MoveScaleQuestionStateToScaleSubmittable < ActiveRecord::Migration
  def up
    add_column :scale_submittables, :minimum, :integer
    add_column :scale_submittables, :maximum, :integer

    connection.insert(<<-SQL)
      INSERT INTO scale_submittables
        (id, created_at, updated_at, minimum, maximum)
      SELECT
        id, created_at, updated_at, minimum, maximum
      FROM questions
      WHERE questions.type = 'ScaleQuestion'
    SQL

    connection.update(<<-SQL)
      UPDATE questions
      SET submittable_id = id, submittable_type = 'ScaleSubmittable'
      WHERE type = 'ScaleQuestion'
    SQL

    remove_column :questions, :minimum
    remove_column :questions, :maximum
  end

  def down
    add_column :questions, :maximum, :integer
    add_column :questions, :minimum, :integer

    connection.update(<<-SQL)
      UPDATE questions
      SET
        minimum = (
          SELECT minimum
          FROM scale_submittables
          WHERE questions.submittable_id = scale_submittables.id
        ),
        maximum = (
          SELECT maximum
          FROM scale_submittables
          WHERE questions.submittable_id = scale_submittables.id
        )
      WHERE questions.submittable_type = 'ScaleSubmittable'
    SQL

    connection.delete('DELETE FROM scale_submittables')

    remove_column :scale_submittables, :maximum
    remove_column :scale_submittables, :minimum
  end
end
