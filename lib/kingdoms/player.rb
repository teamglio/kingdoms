require 'data_mapper'
class Player

	attr_accessor :user_id, :health, :defence, :matter, :matter_rate, :energy, :energy_rate, :intelligence, :intelligence_rate, :deck, :hand, :turn, :moved, :surrender, :last_move

  def draw_card
    card = deck.sample
    hand.push(card)
    deck.delete(card)
  end  

  def discard_card(card)
    hand.delete(card)
    @moved = true    
  end

  # Not tested
  def play_card(card, me, opponent)
    card.affect(me, opponent)
    incur_card_cost(card)
    @moved = true
  end

  def can_afford?(card)
    case card.cost_type
    when 'matter'
      @matter >= card.cost ? true : false
    when 'energy'
      @energy >= card.cost ? true : false
    when 'intelligence'
      @intelligence >= card.cost ? true : false
    end
  end

  def yield
    @matter += @matter_rate
    @energy += @energy_rate
    @intelligence += @intelligence_rate
  end

  private
  def incur_card_cost(card)
    case card.cost_type
    when 'matter'
      @matter -= card.cost
    when 'energy'
      @energy -= card.cost
    when 'intelligence'
      @intelligence -= card.cost
    end
  end

end