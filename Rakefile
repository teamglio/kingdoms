require_relative 'lib/kingdoms.rb'

namespace :db do
  task :clean do
    DataMapper.auto_migrate!
  end
  task :seed do
    DataMapper.auto_migrate!
    u1 = User.create(:mxit_user_id => 'm41162520002', :username => "TestUser1")
    u2 = User.create(:mxit_user_id => 'm41162520003', :username => "TestUser2")
    game_creator = GameCreator.new
    game_config_file_path = File.expand_path('../public/game_configs/castle_wars.yaml', __FILE__)
    game_creator.new_game(u1, u2, game_config_file_path)
  end
end

