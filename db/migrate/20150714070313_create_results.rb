class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.references :lesson, index: true, foreign_key: true
      t.references :word, index: true, foreign_key: true
      t.references :answer, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :results, [:lesson_id, :created_at]
    add_index :results, [:word_id, :created_at]
    add_index :results, [:answer_id, :created_at]
  end
end
