require 'open-uri'

class GameCreator
  
  def new_game(user_1, user_2, game_config_file_path)
    unless user_1.nil? || user_2.nil? || game_config_file_path.nil?
      game_config = YAML.load(open(game_config_file_path).read)
      game = Game.new
      game.game_config_file_path = game_config_file_path
      game.users << user_1
      game.users << user_2
      players = []
      [user_1, user_2].each_with_index do |user, index|
        player = Player.new
        player.user_id = user.id
        player.health = game_config['values']['health']
        player.defence = game_config['values']['defence']
        player.matter = game_config['values']['matter']
        player.energy = game_config['values']['energy']
        player.intelligence = game_config['values']['intelligence']
        player.matter_rate = game_config['values']['matter_rate']
        player.energy_rate = game_config['values']['energy_rate']
        player.intelligence_rate = game_config['values']['intelligence_rate']
        player.deck = build_deck(game_config)
        player.moved = false
        player.turn = index == 0 ? true : false
        player.hand = []
        8.times { player.draw_card }
        players << player
      end
      game.players = players
      game.active = true
      game.start_date = DateTime.now
      game.save
      game
    else
      raise 'Users do not exist or GameConfig is broken'
    end
  end

  def build_deck(game_config)
    deck = []
    game_config['deck'].each do |card_set|
      case card_set['type']
      when 'healer'
        card_set['number'].times do
           deck << Healer.new(card_set['name'], card_set['effect'], card_set['cost'], card_set['cost_type'])
        end
      when 'poisoner'
        card_set['number'].times do
           deck << Poisoner.new(card_set['name'], card_set['effect'], card_set['cost'], card_set['cost_type'])
        end
      when 'leech'
        card_set['number'].times do
           deck << Leech.new(card_set['name'], card_set['effect'], card_set['cost'], card_set['cost_type'])
        end
      when 'defender'
        card_set['number'].times do
           deck << Defender.new(card_set['name'], card_set['effect'], card_set['cost'], card_set['cost_type'])
        end
      when 'reservist'
        card_set['number'].times do
           deck << Reservist.new(card_set['name'], card_set['effect'], card_set['cost'], card_set['cost_type'])
        end
      when 'attacker'
        card_set['number'].times do
           deck << Attacker.new(card_set['name'], card_set['effect'], card_set['cost'], card_set['cost_type'])
        end
      when 'destroyer'
        card_set['number'].times do
           deck << Destroyer.new(card_set['name'], card_set['effect'], card_set['effect_type'], card_set['cost'], card_set['cost_type'])
        end
      when 'stocker'
        card_set['number'].times do
           deck << Stocker.new(card_set['name'], card_set['effect'], card_set['effect_type'], card_set['cost'], card_set['cost_type'])
        end
      when 'saboteur'
        card_set['number'].times do
           deck << Saboteur.new(card_set['name'], card_set['effect'], card_set['cost'], card_set['cost_type'])
        end
      when 'thief'
        card_set['number'].times do
           deck << Thief.new(card_set['name'], card_set['effect'], card_set['cost'], card_set['cost_type'])
        end
      when 'trainer'
        card_set['number'].times do
           deck << Trainer.new(card_set['name'], card_set['effect'], card_set['effect_type'], card_set['cost'], card_set['cost_type'])
        end
      when 'blanket'
        card_set['number'].times do
           deck << Blanket.new(card_set['name'], card_set['effect'], card_set['cost'], card_set['cost_type'])
        end
      else
        raise "Can't handle that card type"
      end
    end
    deck
  end

end