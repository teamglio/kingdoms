class AI

  def initialize(game)
    @game = game
    @ai = User.all(:username => 'Computer').first
  end

  def play
    player = @game.player(@ai)
    opponent = @game.opponent(@ai)
    # Get cards I can afford
    cards_i_can_afford = player.hand.select do |card|
      card if player.can_afford?(card)
    end
    unless cards_i_can_afford.size == 0
      # Play random card
      card = cards_i_can_afford.sample
      player.play_card(card, player, opponent)
      player.discard_card(card)
      player.draw_card
      player.last_move = "played <strong>#{card.name}: #{@game.card_text(card)} (#{card.cost.to_s + @game.vital_label(card.cost_type)[0].downcase})</strong>"
      @game.end_turn      
    else
      # Discard random card
      card = player.hand.sample 
      player.discard_card(card)
      player.draw_card
      player.last_move = "discarded <strong>#{card.name}: #{@game.card_text(card)} (#{card.cost.to_s + @game.vital_label(card.cost_type)[0].downcase})</strong>"
      @game.end_turn
    end
  end
end
