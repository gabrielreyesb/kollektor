class CreateCollectionTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :collection_types do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    
    add_index :collection_types, :name, unique: true
  end
end
