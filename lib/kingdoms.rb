require_relative 'kingdoms/mxit_user.rb'
require_relative 'kingdoms/user.rb'
require_relative 'kingdoms/game.rb'
require_relative 'kingdoms/game_creator.rb'
require_relative 'kingdoms/player.rb'
require_relative 'kingdoms/effect.rb'
require_relative 'kingdoms/card.rb'

DataMapper.setup(:default, ENV['DATABASE_URL'])
DataMapper.finalize
#DataMapper.auto_migrate!
