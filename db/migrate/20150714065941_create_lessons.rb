class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.integer :point
      t.references :user, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :lessons, [:user_id, :created_at]
    add_index :lessons, [:category_id, :created_at]
  end
end
