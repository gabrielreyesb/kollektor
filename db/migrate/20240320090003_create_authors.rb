class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :description
      t.references :genre, null: false, foreign_key: true
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end 