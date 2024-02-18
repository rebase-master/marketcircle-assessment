class CreateDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :details do |t|
      t.references :person, null: false, foreign_key: true
      t.string :title
      t.integer :age
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
