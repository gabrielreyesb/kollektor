class AddUserIdToAlbums < ActiveRecord::Migration[7.1]
  def change
    add_reference :albums, :user, null: true, foreign_key: true
  end
end
