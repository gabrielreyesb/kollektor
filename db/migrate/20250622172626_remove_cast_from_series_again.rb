class RemoveCastFromSeriesAgain < ActiveRecord::Migration[7.1]
  def change
    remove_column :series, :cast, :json
  end
end
