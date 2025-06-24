class CreateTvShows < ActiveRecord::Migration[7.1]
  def change
    create_table :tv_shows do |t|
      t.string :name
      t.text :description
      t.integer :year
      t.references :genre, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
