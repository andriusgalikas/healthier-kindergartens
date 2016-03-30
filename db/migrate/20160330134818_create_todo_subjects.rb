class CreateTodoSubjects < ActiveRecord::Migration
  def change
    create_table :todo_subjects do |t|
      t.integer :todo_id
      t.integer :subject_id

      t.timestamps null: false
    end
  end
end
