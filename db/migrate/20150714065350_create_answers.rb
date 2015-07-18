class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :content
      t.boolean :correct
      t.references :word, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :answers, [:word_id, :created_at]
  end
end
