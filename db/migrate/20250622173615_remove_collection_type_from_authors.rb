class RemoveCollectionTypeFromAuthors < ActiveRecord::Migration[7.1]
  def change
    remove_reference :authors, :collection_type, null: false, foreign_key: true
  end
end
