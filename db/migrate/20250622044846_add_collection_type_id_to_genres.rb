class AddCollectionTypeIdToGenres < ActiveRecord::Migration[7.1]
  def up
    add_column :genres, :collection_type_id, :integer, null: true

    # Ensure 'Music' collection type exists
    execute <<-SQL
      INSERT INTO collection_types (name, description, created_at, updated_at)
      SELECT 'Music', 'Music albums, singles, and other audio recordings', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      WHERE NOT EXISTS (SELECT 1 FROM collection_types WHERE name = 'Music');
    SQL

    # Backfill: assign all genres to the 'Music' collection type
    music_type_id = execute("SELECT id FROM collection_types WHERE name = 'Music' LIMIT 1").first&.fetch('id')
    raise 'Music collection type not found' unless music_type_id
    execute("UPDATE genres SET collection_type_id = #{music_type_id}")

    change_column_null :genres, :collection_type_id, false
    add_index :genres, :collection_type_id
    add_foreign_key :genres, :collection_types
  end

  def down
    remove_foreign_key :genres, :collection_types
    remove_index :genres, :collection_type_id
    remove_column :genres, :collection_type_id
  end
end
