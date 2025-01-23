class StatisticsController < ApplicationController
  def index
    # Total albums count
    @total_albums = Album.count

    # Albums per genre
    @albums_by_genre = Genre.joins(:albums)
                           .group('genres.name')
                           .order('count_all DESC')
                           .count

    # Albums per country
    @albums_by_country = Country.joins(authors: :albums)
                               .group('countries.name')
                               .order('count_all DESC')
                               .count

    # Albums per decade
    decade_calc = Arel.sql('(year / 10) * 10')
    @albums_by_decade = Album.where.not(year: nil)
                            .group(decade_calc)
                            .order(decade_calc)
                            .count
                            .transform_keys { |k| "#{k}s" }
  end
end 