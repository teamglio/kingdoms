require 'open-uri'

class Game
  include DataMapper::Resource

  property :id, Serial
  property :game_config_file_path, URI
  property :players, Object
  property :active, Boolean
  property :start_date, DateTime
  property :end_date, DateTime
  
  has n, :users, :through => Resource

  def vital_label(vital)
    game_config['labels'][vital]
  end

  def vital_colour(vital)
    game_config['colours'][vital]
  end

  def card_text(card)
    if card.is_a? Healer
      "#{vital_label('health')} +#{card.effect}"
    elsif card.is_a? Poisoner
      "enemy #{vital_label('health')} -#{card.effect}"    
    elsif card.is_a? Leech
      "enemy #{vital_label('health')} -#{card.effect} #{vital_label('health')} +#{card.effect}"
    elsif card.is_a? Defender
      "#{vital_label('defence')} +#{card.effect}"
    elsif card.is_a? Reservist
      "#{vital_label('defence')} -#{card.effect} #{vital_label('health')} + #{card.effect}"
    elsif card.is_a? Attacker
      "#{card.effect} attack"
    elsif card.is_a? Destroyer
      "enemy #{vital_label(card.effect_type)} -#{card.effect}"
    elsif card.is_a? Stocker
      "#{vital_label(card.effect_type)} +#{card.effect}"
    elsif card.is_a? Saboteur
      "enemy stock - #{card.effect}"
    elsif card.is_a? Thief
      "transfer #{card.effect} enemy stock"
    elsif card.is_a? Trainer
      "#{vital_label('matter')} +#{card.effect} per turn"
    elsif card.is_a? Blanket
      "-#{card.effect} all enemy +#{card.effect} all"
    end
  end

  def player(user)
    players.find {|player| player.user_id == user.id}
  end

  def opponent(user)
    players.find {|player| player.user_id != user.id}
  end  

  def turn?(user)
    player(user).turn
  end

  def save_game(players) # Not tested
    update(:players => nil)
    update(:players => players)
  end

  def end_turn
    players.find {|player| player.moved}.turn = false
    players.find {|player| !player.moved}.turn = true
    players.find {|player| !player.moved}.yield
    players.each {|player| player.moved = false}
    save_game(players)
  end

  def player_with_100_health
    players.find {|player| player.health == 100}
  end

  def player_with_0_health
    players.find {|player| player.health == 0}
  end

  def player_who_surrendered
    players.find {|player| player.surrender}
  end

  def over?
    if player_with_100_health || player_with_0_health || player_who_surrendered
      true
    else
      false
    end
  end

  def end_game # need test
    if player_with_100_health
      winner = User.get(player_with_100_health.user_id)
    elsif player_with_0_health
      winner = User.get(players.reject {|player| player == player_with_0_health}.first.user_id)
    elsif player_who_surrendered
      winner = User.get(players.reject {|player| player == player_who_surrendered}.first.user_id)
    end
    winner.update(:games_won => winner.games_won + 1) if active
    update(:active => false)
    update(:end_date => DateTime.now)
  end

  private
  def game_config
    YAML.load(open(game_config_file_path).read)
  end

end