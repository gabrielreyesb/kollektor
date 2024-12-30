json.extract! author, :id, :name, :description, :genre_id, :created_at, :updated_at
json.url author_url(author, format: :json)
