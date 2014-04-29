require_relative '../spec_helper.rb'
require 'open-uri'

describe Game do
  before do
    @game = Game.new
    game_config_file_path = File.expand_path("../../../public/game_configs/#{ENV['GAME_CONFIG_FILE']}" ,__FILE__)    
    @game.game_config_file_path = game_config_file_path
    @game_config_file = YAML.load(open(game_config_file_path))
  end
  after do
    Game.all.destroy
    User.all.destroy
  end
  describe "#vital_label(vital)" do
    it "return label for vital as per configuration file" do
      expect(@game.vital_label('health')).to eq @game_config_file['labels']['health']
    end
  end
  describe "#vital_colour(vital)" do
    it "return colour for vital as per configuration file" do
      expect(@game.vital_colour('health')).to eq @game_config_file['colours']['health']
    end
  end
  describe "#card_text(card)" do
    it "return card text for card as per the particular card and configuration file" do
      card = Attacker.new("Attacker", 1, 1, :energy)
      expect(@game.card_text(card)).to be_a String
    end
  end
  describe "#player(user)" do
    it "return own Player for User" do
      user_1 = User.create(:mxit_user_id => 'm41162520002', :username => "TestUser1")
      user_2 = User.create(:mxit_user_id => 'm41162520003', :username => "TestUser2")
      players = []
      [user_1, user_2].each_with_index do |user, index|
        player = Player.new
        player.user_id = user.id
        players << player
      end
      @game.players = players
      expect(@game.player(user_1)).to eq @game.players.find { |player| player.user_id == user_1.id }
    end
  end
  describe "#opponent(user)" do
    it "return opponent Player for User" do
      user_1 = User.create(:mxit_user_id => 'm41162520002', :username => "TestUser1")
      user_2 = User.create(:mxit_user_id => 'm41162520003', :username => "TestUser2")
      players = []
      [user_1, user_2].each_with_index do |user, index|
        player = Player.new
        player.user_id = user.id
        players << player
      end
      @game.players = players
      expect(@game.opponent(user_1)).to eq @game.players.find { |player| player.user_id == user_2.id }
    end
  end
  describe "#turn?(user)" do
    it "return true if it is User's Player's turn, else return false" do
      user_1 = User.create(:mxit_user_id => 'm41162520002', :username => "TestUser1")
      user_2 = User.create(:mxit_user_id => 'm41162520003', :username => "TestUser2")
      players = []
      [user_1, user_2].each_with_index do |user, index|
        player = Player.new
        player.user_id = user.id
        players << player
      end
      @game.players = players
      @game.player(user_1).turn = true
      expect(@game.turn?(user_1)).to eq true      
      @game.player(user_1).turn = false
      expect(@game.turn?(user_1)).to eq false
    end
  end
  describe "#end_turn" do
    it "change Player's whose turn is true to false and Player's whose turn is false to true" do
      user_1 = User.create(:mxit_user_id => 'm41162520002', :username => "TestUser1")
      user_2 = User.create(:mxit_user_id => 'm41162520003', :username => "TestUser2")
      players = []
      [user_1, user_2].each_with_index do |user, index|
        player = Player.new
        player.user_id = user.id
        player.matter = 1
        player.energy = 1
        player.intelligence = 1
        player.matter_rate = 1
        player.energy_rate = 1
        player.intelligence_rate = 1
        players << player
      end
      @game.players = players
      @game.save
      @game.player(user_1).turn = true
      @game.opponent(user_1).turn = false
      @game.player(user_1).moved = true
      @game.end_turn
      expect(@game.player(user_1).turn).to eq false
      expect(@game.opponent(user_1).turn).to eq true
    end
  end
  describe "#player_with_100_health" do
    it "return player with 100 health if available" do
      user_1 = User.create(:mxit_user_id => 'm41162520002', :username => "TestUser1")
      user_2 = User.create(:mxit_user_id => 'm41162520003', :username => "TestUser2")
      players = []
      [user_1, user_2].each_with_index do |user, index|
        player = Player.new
        player.user_id = user.id
        players << player
      end
      @game.players = players
      expect(@game.player_with_100_health).to eq nil
      @game.player(user_1).health = 100
      player_with_100_health = @game.player(user_1)
      expect(@game.player_with_100_health).to eq player_with_100_health
    end
  end
  describe "#player_with_0_health" do
    it "return player with 0 health if available" do
      user_1 = User.create(:mxit_user_id => 'm41162520002', :username => "TestUser1")
      user_2 = User.create(:mxit_user_id => 'm41162520003', :username => "TestUser2")
      players = []
      [user_1, user_2].each_with_index do |user, index|
        player = Player.new
        player.user_id = user.id
        players << player
      end
      @game.players = players
      expect(@game.player_with_0_health).to eq nil
      @game.player(user_1).health = 0
      player_with_0_health = @game.player(user_1)
      expect(@game.player_with_0_health).to eq player_with_0_health
    end
  end
  describe "#player_who_surrendered" do
    it "return player who surrendered if available" do
      user_1 = User.create(:mxit_user_id => 'm41162520002', :username => "TestUser1")
      user_2 = User.create(:mxit_user_id => 'm41162520003', :username => "TestUser2")
      players = []
      [user_1, user_2].each_with_index do |user, index|
        player = Player.new
        player.user_id = user.id
        players << player
      end
      @game.players = players
      expect(@game.player_who_surrendered).to eq nil
      @game.player(user_1).surrender = true
      player_who_surrendered = @game.player(user_1)
      expect(@game.player_who_surrendered).to eq player_who_surrendered
    end
  end
  describe "#over?" do
    context "when player with 100 health" do
      it "return true" do
        user_1 = User.create(:mxit_user_id => 'm41162520002', :username => "TestUser1")
        user_2 = User.create(:mxit_user_id => 'm41162520003', :username => "TestUser2")
        players = []
        [user_1, user_2].each_with_index do |user, index|
          player = Player.new
          player.user_id = user.id
          players << player
        end
        @game.players = players
        @game.player(user_1).health = 100
        expect(@game.over?).to eq true
      end
    end
    context "when player with 0 health" do
      it "return true" do
        user_1 = User.create(:mxit_user_id => 'm41162520002', :username => "TestUser1")
        user_2 = User.create(:mxit_user_id => 'm41162520003', :username => "TestUser2")
        players = []
        [user_1, user_2].each_with_index do |user, index|
          player = Player.new
          player.user_id = user.id
          players << player
        end
        @game.players = players
        @game.player(user_1).health = 0
        expect(@game.over?).to eq true
      end
    end
    context "when player who surrendered" do
      it "return true" do
      user_1 = User.create(:mxit_user_id => 'm41162520002', :username => "TestUser1")
      user_2 = User.create(:mxit_user_id => 'm41162520003', :username => "TestUser2")
      players = []
      [user_1, user_2].each_with_index do |user, index|
        player = Player.new
        player.user_id = user.id
        players << player
      end
      @game.players = players
      @game.player(user_1).surrender = true
      expect(@game.over?).to eq true
      end
    end        
  end  
end
