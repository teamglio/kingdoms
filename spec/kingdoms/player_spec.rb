require_relative '../spec_helper.rb'

describe Player do
  before do
    user = User.create(:mxit_user_id => 'm41162520002', :username => "Test User 1")
    @player = Player.new
    @player.matter = 1 
    @player.energy = 1
    @player.intelligence = 1
    @player.matter_rate = 1
    @player.energy_rate = 1
    @player.intelligence_rate = 1
    @player.user_id = user.id
    @player.deck = [Attacker.new("Attacker", 1, 1, 'energy'), Attacker.new("Attacker", 1, 1, 'energy'), Attacker.new("Attacker", 1, 1, 'energy'), Attacker.new("Attacker", 1, 1, 'energy')]
    @player.hand = [Attacker.new("Attacker", 1, 1, 'energy'), Attacker.new("Attacker", 1, 1, 'energy'), Attacker.new("Attacker", 1, 1, 'energy'), Attacker.new("Attacker", 1, 3, 'energy')]
  end
  after do
    User.all.destroy
  end
  describe "#draw_card" do
    it "the Player's deck should decrease with one" do
      deck_size_before_draw = @player.deck.size
      @player.draw_card
      expect(@player.deck.size).to eq deck_size_before_draw - 1
    end
    it "the Player's hand should decrease with one" do
      hand_size_before_draw = @player.hand.size
      @player.draw_card
      expect(@player.hand.size).to eq hand_size_before_draw + 1
    end
  end
  describe "#discard_card(card)" do
    it "the Player's hand should decrease with one" do
      card = @player.hand.first
      hand_size_before_discard = @player.hand.size
      @player.discard_card(card)
      expect(@player.hand.size).to eq hand_size_before_discard - 1
    end
  end
  describe "#can_afford?(card)" do
    context "when Player can afford card" do
      it "should return true" do
        card = @player.hand.first
        expect(@player.can_afford?(card)).to be true
      end
    end
    context "when Player can't afford card" do
      it "should return false" do
        card = @player.hand.last
        expect(@player.can_afford?(card)).to be false
      end
    end
  end
  describe "#yield" do
    it "should increase the Player's resources by the respective yield" do
      matter_before_yield = @player.matter
      energy_before_yield = @player.energy
      intelligence_before_yield = @player.intelligence
      @player.yield
      expect(@player.matter).to eq matter_before_yield + @player.matter_rate
      expect(@player.energy).to eq energy_before_yield + @player.energy_rate
      expect(@player.intelligence).to eq intelligence_before_yield + @player.intelligence_rate
    end
  end


end