class CreateCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :code, limit: 2

      t.timestamps
    end
    
    add_index :countries, :code, unique: true
  end
end 