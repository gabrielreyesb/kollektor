class AddCollectionTypeIdToAuthors < ActiveRecord::Migration[7.1]
  def up
    add_column :authors, :collection_type_id, :integer, null: true

    # Backfill: assign all authors to the 'Music' collection type
    music_type_id = execute("SELECT id FROM collection_types WHERE name = 'Music' LIMIT 1").first&.fetch('id')
    raise 'Music collection type not found' unless music_type_id
    execute("UPDATE authors SET collection_type_id = #{music_type_id}")

    change_column_null :authors, :collection_type_id, false
    add_index :authors, :collection_type_id
    add_foreign_key :authors, :collection_types
  end

  def down
    remove_foreign_key :authors, :collection_types
    remove_index :authors, :collection_type_id
    remove_column :authors, :collection_type_id
  end
end
