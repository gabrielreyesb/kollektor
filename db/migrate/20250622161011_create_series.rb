class CreateSeries < ActiveRecord::Migration[7.1]
  def change
    create_table :series do |t|
      t.string :name
      t.text :description
      t.integer :year
      t.references :genre, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.json :cast

      t.timestamps
    end
  end
end
