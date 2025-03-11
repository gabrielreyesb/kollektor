namespace :migrate_data do
  desc 'Assign existing albums, authors, and genres to a user'
  task assign_to_user: :environment do
    # Find the user to assign records to (default to first user)
    user_email = ENV['USER_EMAIL']
    user = if user_email
             User.find_by(email: user_email)
           else
             User.first
           end
    
    if user.nil?
      puts "No user found. Please create a user first or specify USER_EMAIL."
      exit
    end

    puts "Assigning records to user: #{user.email}"
    
    # Assign all unassigned albums to this user
    unassigned_albums = Album.where(user_id: nil)
    count = unassigned_albums.count
    unassigned_albums.update_all(user_id: user.id)
    puts "Assigned #{count} albums to #{user.email}"
    
    # Assign all unassigned authors to this user
    unassigned_authors = Author.where(user_id: nil)
    count = unassigned_authors.count
    unassigned_authors.update_all(user_id: user.id)
    puts "Assigned #{count} authors to #{user.email}"
    
    # Assign all unassigned genres to this user
    unassigned_genres = Genre.where(user_id: nil)
    count = unassigned_genres.count
    unassigned_genres.update_all(user_id: user.id)
    puts "Assigned #{count} genres to #{user.email}"
    
    puts "Data migration completed successfully!"
  end
end 