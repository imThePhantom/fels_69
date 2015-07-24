class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :answers, :is_correct, :correct
  end
end
