class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :discription
      t.string :status

      t.timestamps null: false
    end
  end
end
