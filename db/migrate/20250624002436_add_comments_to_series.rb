class AddCommentsToSeries < ActiveRecord::Migration[7.1]
  def change
    add_column :series, :comments, :text
  end
end
