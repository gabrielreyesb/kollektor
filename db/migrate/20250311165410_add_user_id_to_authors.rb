class AddUserIdToAuthors < ActiveRecord::Migration[7.1]
  def change
    add_reference :authors, :user, null: true, foreign_key: true
  end
end
