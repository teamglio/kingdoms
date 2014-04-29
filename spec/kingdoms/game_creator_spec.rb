require_relative '../spec_helper.rb'

describe GameCreator do
  after do
    Game.all.destroy
    User.all.destroy
  end
  describe "#new_game(user_1, user_2, game_config)" do
    it "return a Game" do
      user_1 = User.create(:mxit_user_id => 'm41162520002', :username => "TestUser1")
      user_2 = User.create(:mxit_user_id => 'm41162520003', :username => "TestUser2")
      game_config_file_path = File.expand_path("../../../public/game_configs/#{ENV['GAME_CONFIG_FILE']}" ,__FILE__)
      game_creator = GameCreator.new
      expect(game_creator.new_game(user_1, user_2, game_config_file_path)).to be_a Game
    end
  end
end