require_relative '../spec_helper.rb'

describe Card do

  before do
    @player = Player.new
    @player.health = 50
    @player.defence = 50
    @player.matter = 5
    @player.energy = 5
    @player.intelligence = 5
    @player.matter_rate = 2
    @player.energy_rate = 2
    @player.intelligence_rate = 2
    @card = Card.new(nil, nil, nil, nil)
  end

  describe "#increase_health(player, amount)" do
    context "when given a player and amount less than 100" do
      it "then player's health must increase with amount" do
        initial_health = @player.health
        @card.increase_health(@player, 10)
        expect(@player.health).to eq initial_health + 10
      end
    end
    context "when given a player and amount larger than 100" do
      it "then player's health must increase to a maximum of 100" do
        initial_health = @player.health
        @card.increase_health(@player, 1000)
        expect(@player.health).to eq 100
      end
    end
  end

  describe "#decrease_health(player, amount)" do
    context "when given a player and amount less than 100" do
      it "then player's health must decrease with amount" do
        initial_health = @player.health
        @card.decrease_health(@player, 10)
        expect(@player.health).to eq initial_health - 10
      end
    end
    context "when given a player and amount larger than 100" do
      it "then player's health must decrease to a minimum of 0" do
        initial_health = @player.health
        @card.decrease_health(@player, 1000)
        expect(@player.health).to eq 0
      end
    end
  end

  describe "#increase_defence(player, amount)" do
    context "when given a player and amount less than 100" do
      it "then player's defence must increase with amount" do
        initial_defence = @player.defence
        @card.increase_defence(@player, 10)
        expect(@player.defence).to eq initial_defence + 10
      end
    end
  end

  describe "#decrease_defence(player, amount)" do
    context "when given a player and amount less than 100" do
      it "then player's defence must decrease with amount" do
        initial_defence = @player.defence
        @card.decrease_defence(@player, 10)
        expect(@player.defence).to eq initial_defence - 10
      end
    end
  end  

  describe "#decrease_health_and_defence(player, amount)" do

    context "when given a player and amount less than player's defence" do
      it "then player's defence must decrease with amount" do
        initial_health = @player.health
        initial_defence = @player.defence
        amount = 10
        @card.decrease_health_and_defence(@player, amount)
        expect(@player.defence).to eq initial_defence - amount
        expect(@player.health).to eq initial_health
      end
    end

    context "when given a player and amount greater than player's defence" do
      it "then player's defence must decrease to 0 and player's health must decrease with remainder" do
        initial_health = @player.health
        initial_defence = @player.defence
        amount = 70
        @card.decrease_health_and_defence(@player, amount)
        expect(@player.defence).to eq 0
        expect(@player.health).to eq initial_health - (amount - initial_defence)
      end
    end

    context "when given a player and amount greater than player's defence and health" do
      it "then player's defence must decrease to 0 and player's health must decrease to 0" do
        initial_health = @player.health
        initial_defence = @player.defence
        amount = 700
        @card.decrease_health_and_defence(@player, amount)
        expect(@player.defence).to eq 0
        expect(@player.health).to eq 0
      end
    end    

  end    

  describe "#increase_stock(player, amount)" do
    context "when given a stock type, player and amount" do
      it "then player's stock of that type must increase with amount" do
        initial_matter_stock = @player.matter
        @card.increase_stock('matter', @player, 10)
        expect(@player.matter).to eq initial_matter_stock + 10

        initial_energy_stock = @player.energy
        @card.increase_stock('energy', @player, 10)
        expect(@player.energy).to eq initial_energy_stock + 10

        initial_intelligence_stock = @player.intelligence
        @card.increase_stock('intelligence', @player, 10)
        expect(@player.intelligence).to eq initial_intelligence_stock + 10
      end
    end
  end

  describe "#decrease_stock(player, amount)" do
    context "when given a stock type, player and amount less than current stock" do
      it "then player's stock of that type must decrease with amount" do
        amount = 2
        initial_matter_stock = @player.matter
        @card.decrease_stock('matter', @player, amount)
        expect(@player.matter).to eq initial_matter_stock - amount
        initial_energy_stock = @player.energy
        @card.decrease_stock('energy', @player, amount)
        expect(@player.energy).to eq initial_energy_stock - amount
        initial_intelligence_stock = @player.intelligence
        @card.decrease_stock('intelligence', @player, amount)
        expect(@player.intelligence).to eq initial_intelligence_stock - amount
      end
    end
    context "when given a stock type, player and amount larger than current stock" do
      it "then player's stock of that type must decrease to 0" do
        amount = 100
        initial_matter_stock = @player.matter
        @card.decrease_stock('matter', @player, amount)
        expect(@player.matter).to eq 0
        initial_energy_stock = @player.energy
        @card.decrease_stock('energy', @player, amount)
        expect(@player.energy).to eq 0
        initial_intelligence_stock = @player.intelligence
        @card.decrease_stock('intelligence', @player, amount)
        expect(@player.intelligence).to eq 0
      end
    end    
  end

  describe "#increase_rate(player, amount)" do
    context "when given a stock type, player and amount" do
      it "then player's rate of that type must increase with amount" do
        amount = 2
        initial_matter_rate = @player.matter_rate
        @card.increase_rate('matter', @player, amount)
        expect(@player.matter_rate).to eq initial_matter_rate + amount
        initial_energy_rate = @player.energy_rate
        @card.increase_rate('energy', @player, amount)
        expect(@player.energy_rate).to eq initial_energy_rate + amount
        initial_intelligence_rate = @player.intelligence_rate
        @card.increase_rate('intelligence', @player, amount)
        expect(@player.intelligence_rate).to eq initial_intelligence_rate + amount
      end
    end
  end

  describe "#decrease__rate(player, amount)" do
    context "when given a stock type, player and amount less than current rate" do
      it "then player's rate of that type must decrease with amount" do
        amount = 2
        initial_matter_rate = @player.matter_rate
        @card.decrease_rate('matter', @player, amount)
        expect(@player.matter_rate).to eq initial_matter_rate - amount
        initial_energy_rate = @player.energy_rate
        @card.decrease_rate('energy', @player, amount)
        expect(@player.energy_rate).to eq initial_energy_rate - amount
        initial_intelligence_rate = @player.intelligence_rate
        @card.decrease_rate('intelligence', @player, amount)
        expect(@player.intelligence_rate).to eq initial_intelligence_rate - amount
      end
    end
    context "when given a stock type, player and amount larger than current rate" do
      it "then player's rate of that type must decrease to 0" do
        amount = 100
        initial_matter_rate = @player.matter_rate
        @card.decrease_rate('matter', @player, amount)
        expect(@player.matter_rate).to eq 0
        initial_energy_rate = @player.energy_rate
        @card.decrease_rate('energy', @player, amount)
        expect(@player.energy_rate).to eq 0
        initial_intelligence_rate = @player.intelligence_rate
        @card.decrease_rate('intelligence', @player, amount)
        expect(@player.intelligence_rate).to eq 0
      end
    end     
  end  

end