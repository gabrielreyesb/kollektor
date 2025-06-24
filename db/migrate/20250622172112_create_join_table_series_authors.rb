class CreateJoinTableSeriesAuthors < ActiveRecord::Migration[7.1]
  def change
    create_join_table :series, :authors do |t|
      # t.index [:series_id, :author_id]
      # t.index [:author_id, :series_id]
    end
  end
end
