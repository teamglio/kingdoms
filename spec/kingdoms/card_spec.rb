require_relative '../spec_helper.rb'

describe Card do
  before do
    @me = Player.new
    @me.health = 50
    @me.defence = 50
    @me.matter = 5
    @me.energy = 5
    @me.intelligence = 5
    @me.matter_rate = 2
    @me.energy_rate = 2
    @me.intelligence_rate = 2
    @opponent = Player.new
    @opponent.health = 50
    @opponent.defence = 50
    @opponent.matter = 5
    @opponent.energy = 5
    @opponent.intelligence = 5
    @opponent.matter_rate = 2
    @opponent.energy_rate = 2
    @opponent.intelligence_rate = 2    
  end

  describe Healer do
    describe "#affect(player)" do
      context "when given an effect smaller than 100" do
        it "then player's health must be increased with that effect" do
          initial_health = @me.health
          effect = 10
          healer = Healer.new('Healer', effect, 1, 'matter')
          healer.affect(@me, @opponent)
          expect(@me.health).to eq initial_health + effect
        end
      end

      context "when given an effect larger than 100" do
        it "then player's health must be equal to 100" do
          initial_health = @me.health
          effect = 1000
          healer = Healer.new('Healer', effect, 1, 'matter')
          healer.affect(@me, @opponent)
          expect(@me.health).to eq 100
        end
      end
    end
  end

  describe Poisoner do
    describe "#affect(player)" do
      context "when given an effect smaller than 100" do
        it "then player's health must be decreased with that effect" do
          initial_health = @me.health
          effect = 10
          poisoner = Poisoner.new('Poisoner', effect, 1, 'matter')
          poisoner.affect(@me, @opponent)
          expect(@opponent.health).to eq initial_health - effect       
        end
      end
      context "when given an effect larger than 100" do
        it "then player's health must be equal to 0" do
          initial_health = @me.health
          effect = 1000
          poisoner = Poisoner.new('Poisoner', effect, 1, 'matter')
          poisoner.affect(@me, @opponent)
          expect(@opponent.health).to eq 0
        end
      end
    end
  end

  describe Leech do
    describe "#affect(player1, player2)" do
      context "when given an effect smaller than 100" do
        it "then one player's health must be decreased with the effect and another player's health must be increased with the effect" do
          player1_initial_health = @me.health
          player2_initial_health = @opponent.health
          effect = 10
          leech = Leech.new('Leech', effect, 1, 'matter')
          leech.affect(@me, @opponent)
          expect(@opponent.health).to eq player1_initial_health - effect
          expect(@me.health).to eq player2_initial_health + effect
        end
      end
      context "when given an effect larger than 100" do
        it "then one player's health must be decreased to 0 and another player's health must be increased to 100" do
          player1_initial_health = @me.health
          player2_initial_health = @opponent.health
          effect = 1000
          leech = Leech.new('Leech', effect, 1, 'matter')
          leech.affect(@me, @opponent)
          expect(@opponent.health).to eq 0
          expect(@me.health).to eq 100
        end
      end      
    end
  end

  describe Defender do
    describe "#affect(player)" do
      context "when given an effect" do
        it "then player's defence must increase with effect" do
          initial_defence = @me.defence
          effect = 10
          defender = Defender.new('Defender', effect, 1, 'matter')
          defender.affect(@me, @opponent)
          expect(@me.defence).to eq initial_defence + effect
        end
      end
    end
  end

  describe Reservist do
    describe "#affect(player)" do
      context "when given an effect" do
        it "then player's defence must decrease with effect and player's health must increase with effect" do
          initial_defence = @me.defence
          initial_health = @me.health
          effect = 10
          reservist = Reservist.new('Reservist', effect, 1, 'matter')
          reservist.affect(@me, @opponent)
          expect(@me.defence).to eq initial_defence - effect
          expect(@me.health).to eq initial_health + effect
        end
      end
    end
  end

  describe Attacker do
    describe "#affect(player)" do
      context "when given an effect that is smaller than player's defence" do
        it "then player's defence must decrease with effect" do
          initial_defence = @opponent.defence
          initial_health = @opponent.health
          effect = 10
          attacker = Attacker.new('Attacker', effect, 1, 'matter')
          attacker.affect(@me, @opponent)
          expect(@opponent.defence).to eq initial_defence - effect
          expect(@opponent.health).to eq initial_health
        end
      end
      context "when given an effect that is larger than player's defence" do
        it "then player's defence must decrease to zero and player's health must decrease with effect" do
          initial_defence = @opponent.defence
          initial_health = @opponent.health
          effect = 10 + initial_defence
          attacker = Attacker.new('Attacker', effect, 1, 'matter')
          attacker.affect(@me, @opponent)
          expect(@opponent.defence).to eq 0
          expect(@opponent.health).to eq initial_health - (effect - initial_defence)
        end
      end
      context "when given an effect that is larger than 100" do
        it "then player's defence and health must decrease to zero" do
          initial_defence = @opponent.defence
          initial_health = @opponent.health
          effect = 1000
          attacker = Attacker.new('Attacker', effect, 1, 'matter')
          attacker.affect(@me, @opponent)
          expect(@opponent.defence).to eq 0
          expect(@opponent.health).to eq 0
        end
      end          
    end
  end

  describe Destroyer do
    describe "#affect(player)" do
      context "when given an effect" do
        it "then player's stock must decrease with effect" do
          initial_matter = @opponent.matter
          initial_energy = @opponent.energy
          initial_intelligence = @opponent.intelligence
          effect = 2
          destroyer = Destroyer.new('Destroyer', effect, 'matter', 1, 'matter')
          destroyer.affect(@me, @opponent)
          destroyer = Destroyer.new('Destroyer', effect, 'energy', 1, 'matter')
          destroyer.affect(@me, @opponent)
          destroyer = Destroyer.new('Destroyer', effect, 'intelligence', 1, 'matter')
          destroyer.affect(@me, @opponent)
          expect(@opponent.matter).to eq initial_matter - effect
          expect(@opponent.energy).to eq initial_energy - effect
          expect(@opponent.intelligence).to eq initial_intelligence - effect
        end
      end
    end
  end

  describe Stocker do
    describe "#affect(player)" do
      context "when given an effect" do
        it "then player's stock must increase with effect" do
          initial_matter = @me.matter
          initial_energy = @me.energy
          initial_intelligence = @me.intelligence
          effect = 2     
          stocker = Stocker.new('Stocker', effect, 'matter', 1, 'matter')
          stocker.affect(@me, @opponent)
          stocker = Stocker.new('Stocker', effect, 'energy', 1, 'matter')
          stocker.affect(@me, @opponent)
          stocker = Stocker.new('Stocker', effect, 'intelligence', 1, 'matter')
          stocker.affect(@me, @opponent)
          expect(@me.matter).to eq initial_matter + effect
          expect(@me.energy).to eq initial_energy + effect
          expect(@me.intelligence).to eq initial_intelligence + effect
        end
      end
    end
  end

  describe Saboteur do
    describe "#affect(player)" do
      context "when given an effect smaller than 100" do
        it "then all player's stock must decrease with effect" do
          initial_matter = @opponent.matter
          initial_energy = @opponent.energy
          initial_intelligence = @opponent.intelligence
          effect = 2   
          sabouteur = Saboteur.new('Sabouteur', effect, 1, 'matter')
          sabouteur.affect(@me, @opponent)          
          expect(@opponent.matter).to eq initial_matter - effect
          expect(@opponent.energy).to eq initial_energy - effect
          expect(@opponent.intelligence).to eq initial_intelligence - effect
        end
      end
      context "when given an effect larger than 100" do
        it "then all player's stock must decrease to zero" do
          initial_matter = @opponent.matter
          initial_energy = @opponent.energy
          initial_intelligence = @opponent.intelligence
          effect = 1000   
          sabouteur = Saboteur.new('Sabouteur', effect, 1, 'matter')
          sabouteur.affect(@me, @opponent)          
          expect(@opponent.matter).to eq 0
          expect(@opponent.energy).to eq 0
          expect(@opponent.intelligence).to eq 0
        end
      end      
    end
  end  

describe Thief do
    describe "#affect(player1, player2)" do
      context "when given an effect" do
        it "then all stock of player1 must decrease with effect and all stock of player2 must increase with effect" do
          me_initial_matter = @me.matter
          me_initial_energy = @me.energy
          me_initial_intelligence = @me.intelligence
          opponent_initial_matter = @opponent.matter
          opponent_initial_energy = @opponent.energy
          opponent_initial_intelligence = @opponent.intelligence
          effect = 2    
          thief = Thief.new('Thief', effect, 1, 'matter')
          thief.affect(@me, @opponent)
          expect(@opponent.matter).to eq opponent_initial_matter - effect
          expect(@opponent.energy).to eq opponent_initial_energy - effect
          expect(@opponent.intelligence).to eq opponent_initial_intelligence - effect
          expect(@me.matter).to eq me_initial_matter + effect
          expect(@me.energy).to eq me_initial_energy + effect
          expect(@me.intelligence).to eq me_initial_intelligence + effect
        end
      end
    end
  end

describe Trainer do
    describe "#affect(player)" do
      context "when given an effect" do
        it "then yield rate of player increase with effect" do
          initial_matter_rate = @me.matter_rate
          initial_energy_rate = @me.energy_rate
          initial_intelligence_rate = @me.intelligence_rate
          effect = 2   
          trainer = Trainer.new('Trainer', effect, 'matter', 1, 'matter')
          trainer.affect(@me, @opponent)
          trainer = Trainer.new('Trainer', effect, 'energy', 1, 'matter')
          trainer.affect(@me, @opponent)
          trainer = Trainer.new('Trainer', effect, 'intelligence', 1, 'matter')
          trainer.affect(@me, @opponent)        
          expect(@me.matter_rate).to eq initial_matter_rate + effect
          expect(@me.energy_rate).to eq initial_energy_rate + effect
          expect(@me.intelligence_rate).to eq initial_intelligence_rate + effect
        end
      end
    end
  end

describe Blanket do
    describe "#affect(player1, player2)" do
      context "when given an effect" do
        it "then everything of player1 must decrease with effect and everything of player2 must increase with effect" do
          me_initial_health = @me.health
          me_initial_defence = @me.defence
          me_initial_matter = @me.matter
          me_initial_energy = @me.energy
          me_initial_intelligence = @me.intelligence
          me_initial_matter_rate = @me.matter_rate
          me_initial_energy_rate = @me.energy_rate
          me_initial_intelligence_rate = @me.intelligence_rate
          opponent_initial_health = @opponent.health
          opponent_initial_defence = @opponent.defence
          opponent_initial_matter = @opponent.matter
          opponent_initial_energy = @opponent.energy
          opponent_initial_intelligence = @opponent.intelligence
          opponent_initial_matter_rate = @opponent.matter_rate
          opponent_initial_energy_rate = @opponent.energy_rate
          opponent_initial_intelligence_rate = @opponent.intelligence_rate
          effect = 1    
          blanket = Blanket.new('Blanket', effect, 1, 'matter')
          blanket.affect(@me, @opponent)
          expect(@opponent.health).to eq opponent_initial_health - effect
          expect(@opponent.defence).to eq opponent_initial_defence - effect
          expect(@opponent.matter).to eq opponent_initial_matter - effect
          expect(@opponent.energy).to eq opponent_initial_energy - effect
          expect(@opponent.intelligence).to eq opponent_initial_intelligence - effect
          expect(@opponent.matter_rate).to eq opponent_initial_matter_rate - effect
          expect(@opponent.energy_rate).to eq opponent_initial_energy_rate - effect
          expect(@opponent.intelligence_rate).to eq opponent_initial_intelligence_rate - effect
          expect(@me.health).to eq me_initial_health + effect
          expect(@me.defence).to eq me_initial_defence + effect
          expect(@me.matter).to eq me_initial_matter + effect
          expect(@me.energy).to eq me_initial_energy + effect
          expect(@me.intelligence).to eq me_initial_intelligence + effect
          expect(@me.matter_rate).to eq opponent_initial_matter_rate + effect
          expect(@me.energy_rate).to eq opponent_initial_energy_rate + effect
          expect(@me.intelligence_rate).to eq opponent_initial_intelligence_rate + effect
        end
      end
    end
  end  

end

=begin
# Tests for cards
class TestCard < MiniTest::Test

  def setup
    user_1 = User.create(:user_id => 'foo')
    user_2 = User.create(:user_id => 'bar')
    game = Game.new_game(user_1, user_2)
    @me = game.player_1
    @opponent = game.player_2
  end

  # Health cards
  def test_healer_card
    initial_health = @me.health
    effect = 10
    healer = Healer.new('Healer', effect, 1, 'matter')
    healer.affect(@me)
    assert_equal(initial_health + effect, @me.health)
  end

  def test_healer_card_with_large_effect
    initial_health = @me.health
    effect = 1000
    healer = Healer.new('Healer', effect, 1, 'matter')
    healer.affect(@me)
    assert_equal(100, @me.health)    
  end

  def test_poisoner_card
    initial_health = @me.health
    effect = 10
    poisoner = Poisoner.new('Poisoner', effect, 1, 'matter')
    poisoner.affect(@me)
    assert_equal(initial_health - effect, @me.health)
  end

  def test_poisoner_card_with_large_effect
    initial_health = @me.health
    effect = 1000
    poisoner = Poisoner.new('Poisoner', effect, 1, 'matter')
    poisoner.affect(@me)
    assert_equal(0, @me.health)    
  end

  def test_leech_card
    player1_initial_health = @me.health
    player2_initial_health = @opponent.health
    effect = 10
    leech = Leech.new('Leech', effect, 1, 'matter')
    leech.affect(@me, @opponent)
    assert_equal(player1_initial_health - effect, @me.health)
    assert_equal(player2_initial_health + effect, @opponent.health)    
  end

  def test_leech_card_with_large_effect
    player1_initial_health = @me.health
    player2_initial_health = @opponent.health
    effect = 1000
    leech = Leech.new('Leech', effect, 1, 'matter')
    leech.affect(@me, @opponent)
    assert_equal(0, @me.health)
    assert_equal(100, @opponent.health)
  end

  # Defence cards

  def test_defender_card
    initial_defence = @me.defence
    effect = 10
    defender = Defender.new('Defender', effect, 1, 'matter')
    defender.affect(@me)
    assert_equal(initial_defence + effect, @me.defence)   
  end

  # Health-and-defence hybrid cards

  def test_reservist_card
    initial_defence = @me.defence
    initial_health = @me.health
    effect = 10
    reservist = Reservist.new('Reservist', effect, 1, 'matter')
    reservist.affect(@me)
    assert_equal(initial_defence - effect, @me.defence)
    assert_equal(initial_health + effect, @me.health)      
  end

  def test_attacker_card_with_effect_into_defence
    initial_defence = @me.defence
    initial_health = @me.health
    effect = 10
    reservist = Attacker.new('Attacker', effect, 1, 'matter')
    reservist.affect(@me)
    assert_equal(initial_defence - effect, @me.defence)
    assert_equal(initial_health, @me.health) 
  end

  def test_attacker_card_with_effect_into_health
    initial_defence = @me.defence
    initial_health = @me.health
    effect = 10 + initial_defence
    reservist = Attacker.new('Attacker', effect, 1, 'matter')
    reservist.affect(@me)
    assert_equal(0, @me.defence)
    assert_equal(initial_health - (effect - initial_defence), @me.health)
  end

  def test_attacker_card_with_large_effect
    initial_defence = @me.defence
    initial_health = @me.health
    effect = 1000
    reservist = Attacker.new('Attacker', effect, 1, 'matter')
    reservist.affect(@me)
    assert_equal(0, @me.defence)
    assert_equal(0, @me.health)
  end

  # Stock cards
  def test_destroyer_card
    initial_matter = @me.matter
    initial_energy = @me.energy
    initial_intelligence = @me.intelligence
    effect = 2    
    destroyer = Destroyer.new('Destroyer', effect, 'matter', 1, 'matter')
    destroyer.affect(@me)
    destroyer = Destroyer.new('Destroyer', effect, 'energy', 1, 'matter')
    destroyer.affect(@me)
    destroyer = Destroyer.new('Destroyer', effect, 'intelligence', 1, 'matter')
    destroyer.affect(@me)
    assert_equal(initial_matter - effect, @me.matter)
    assert_equal(initial_energy - effect, @me.energy)
    assert_equal(initial_intelligence - effect, @me.intelligence)
  end

  def test_stocker_card
    initial_matter = @me.matter
    initial_energy = @me.energy
    initial_intelligence = @me.intelligence
    effect = 2    
    stocker = Stocker.new('Stocker', effect, 'matter', 1, 'matter')
    stocker.affect(@me)
    stocker = Stocker.new('Stocker', effect, 'energy', 1, 'matter')
    stocker.affect(@me)
    stocker = Stocker.new('Stocker', effect, 'intelligence', 1, 'matter')
    stocker.affect(@me)
    assert_equal(initial_matter + effect, @me.matter)
    assert_equal(initial_energy + effect, @me.energy)
    assert_equal(initial_intelligence + effect, @me.intelligence)
  end

  def test_saboteur_card
    initial_matter = @me.matter
    initial_energy = @me.energy
    initial_intelligence = @me.intelligence
    effect = 2    
    sabouteur = Saboteur.new('Sabouteur', effect, 1, 'matter')
    sabouteur.affect(@me)          
    assert_equal(initial_matter - effect, @me.matter)
    assert_equal(initial_energy - effect, @me.energy)
    assert_equal(initial_intelligence - effect, @me.intelligence)
  end

  def test_saboteur_card_with_large_effect
    initial_matter = @me.matter
    initial_energy = @me.energy
    initial_intelligence = @me.intelligence
    effect = 100   
    sabouteur = Saboteur.new('Sabouteur', effect, 1, 'matter')
    sabouteur.affect(@me)   
    assert_equal(0, @me.matter)
    assert_equal(0, @me.energy)
    assert_equal(0, @me.intelligence)
  end  

  def test_thief_card
    player1_initial_matter = @me.matter
    player1_initial_energy = @me.energy
    player1_initial_intelligence = @me.intelligence
    player2_initial_matter = @opponent.matter
    player2_initial_energy = @opponent.energy
    player2_initial_intelligence = @opponent.intelligence
    effect = 2    
    thief = Thief.new('Thief', effect, 1, 'matter')
    thief.affect(@me, @opponent)
    assert_equal(player1_initial_matter - effect, @me.matter)
    assert_equal(player1_initial_energy - effect, @me.energy)
    assert_equal(player1_initial_intelligence - effect, @me.intelligence)
    assert_equal(player2_initial_matter + effect, @opponent.matter)
    assert_equal(player2_initial_energy + effect, @opponent.energy)
    assert_equal(player2_initial_intelligence + effect, @opponent.intelligence)
  end   
  
  # Rate cards

  def test_trainer_card
    initial_matter_rate = @me.matter_rate
    initial_energy_rate = @me.energy_rate
    initial_intelligence_rate = @me.intelligence_rate
    effect = 2   
    trainer = Trainer.new('Trainer', effect, 'matter', 1, 'matter')
    trainer.affect(@me)
    trainer = Trainer.new('Trainer', effect, 'energy', 1, 'matter')
    trainer.affect(@me)
    trainer = Trainer.new('Trainer', effect, 'intelligence', 1, 'matter')
    trainer.affect(@me)        
    assert_equal(initial_matter_rate + effect, @me.matter_rate)
    assert_equal(initial_energy_rate + effect, @me.energy_rate)
    assert_equal(initial_intelligence_rate + effect, @me.intelligence_rate)
  end   

  # Blanket cards

  def test_blanket_card
    player1_initial_health = @me.health
    player1_initial_defence = @me.defence
    player1_initial_matter = @me.matter
    player1_initial_energy = @me.energy
    player1_initial_intelligence = @me.intelligence
    player1_initial_matter_rate = @me.matter_rate
    player1_initial_energy_rate = @me.energy_rate
    player1_initial_intelligence_rate = @me.intelligence_rate
    player2_initial_health = @opponent.health
    player2_initial_defence = @opponent.defence
    player2_initial_matter = @opponent.matter
    player2_initial_energy = @opponent.energy
    player2_initial_intelligence = @opponent.intelligence
    player2_initial_matter_rate = @opponent.matter_rate
    player2_initial_energy_rate = @opponent.energy_rate
    player2_initial_intelligence_rate = @opponent.intelligence_rate
    effect = 1    
    blanket = Blanket.new('Blanket', effect, 1, 'matter')
    blanket.affect(@me, @opponent)
    assert_equal(player1_initial_health - effect, @me.health)
    assert_equal(player1_initial_defence - effect, @me.defence)
    assert_equal(player1_initial_matter - effect, @me.matter)
    assert_equal(player1_initial_energy - effect, @me.energy)
    assert_equal(player1_initial_intelligence - effect, @me.intelligence)
    assert_equal(player1_initial_matter_rate - effect, @me.matter_rate)
    assert_equal(player1_initial_energy_rate - effect, @me.energy_rate)
    assert_equal(player1_initial_intelligence_rate - effect, @me.intelligence_rate)
    assert_equal(player2_initial_health + effect, @opponent.health)
    assert_equal(player2_initial_defence + effect, @opponent.defence)
    assert_equal(player2_initial_matter + effect, @opponent.matter)
    assert_equal(player2_initial_energy + effect, @opponent.energy)
    assert_equal(player2_initial_intelligence + effect, @opponent.intelligence)
    assert_equal(player2_initial_matter_rate + effect, @opponent.matter_rate)
    assert_equal(player2_initial_energy_rate + effect, @opponent.energy_rate)
    assert_equal(player2_initial_intelligence_rate + effect, @opponent.intelligence_rate)      
  end

  def teardown
    GameSession.all.destroy    
    User.all.destroy
    Game.all.destroy
  end

end
=end
