require 'data_mapper'

class User
  include DataMapper::Resource
  
  property :id, Serial
  property :mxit_user_id, Text
  property :username, Text
  property :games_won, Integer, :default => 0
  
  property :sign_up_date, DateTime
  property :last_login_date, DateTime

  property :in_lobby, Boolean

  has n, :games, :through => Resource
  #has n, :airtime_rewards
  #has n, :plays
  #has n, :points_rewards
end

