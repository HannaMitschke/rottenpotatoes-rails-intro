class Movie < ActiveRecord::Base
    def self.all_ratings # self b/c going to use this on Movie itself not an instance of Movie
        ['G','PG','PG-13','R']
    end
    def self.with_ratings(ratings)
        Movie.where(rating: ratings)
    end
end
