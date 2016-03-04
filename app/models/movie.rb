class Movie < ActiveRecord::Base
 #return array of ratings
  def self.list_of_ratings
      ratings_list = ['G','PG','PG-13','R','NC-17']
      return ratings_list
  end
end
