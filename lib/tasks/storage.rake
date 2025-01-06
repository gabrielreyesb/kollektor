namespace :storage do
  desc "Clean up broken Active Storage attachments"
  task cleanup: :environment do
    Album.all.each do |album|
      if album.cover_image.attached?
        begin
          album.cover_image.variant(resize_to_fill: [300, 300]).processed
        rescue ActiveStorage::FileNotFoundError
          puts "Cleaning up broken attachment for Album: #{album.id}"
          album.cover_image.purge
        end
      end
    end
  end
end 