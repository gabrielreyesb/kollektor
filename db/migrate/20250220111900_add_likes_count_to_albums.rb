class AddLikesCountToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :likes_count, :integer, default: 0, null: false
  end
end 