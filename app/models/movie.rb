class Movie < ActiveRecord::Base

  attr_accessible :title, :rating, :description, :release_date

  RATINGS = ["G", "PG", "PG-13", "R", "NC-17"]

end
