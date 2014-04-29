require 'dotenv'
Dotenv.load

require 'sinatra'
require 'sinatra/flash'
require 'nestful'
require_relative 'lib/kingdoms.rb'

enable :sessions
register Sinatra::Flash

helpers do
  def game_config_file_path
    File.expand_path("../public/game_configs/#{ENV['GAME_CONFIG_FILE']}", __FILE__)
  end
  def user
    mxit_user = MxitUser.new(request.env)
    User.first(:mxit_user_id => mxit_user.user_id)
  end
  def new_user
    mxit_user = MxitUser.new(request.env)
    User.create(:mxit_user_id => mxit_user.user_id, :username => mxit_user.nickname)
  end
  def game_over_message
    if @game.player_with_100_health == @game.player(user)
      erb "<span style='color: green;>You got your #{@game.vital_label('health')} to 100. You win!</span>"
    elsif @game.player_with_100_health == @game.opponent(user)
      erb "<span style='color: red;'>Your opponent's #{@game.vital_label('health')} is 100. You lose!</span>"
    elsif @game.player_with_0_health == @game.player(user)
      erb "<span style='color: red;'>Your #{@game.vital_label('health')} is 0. You lose!</span>"
    elsif @game.player_with_0_health == @game.opponent(user)
      erb "<span style='color: green;'>Your opponent's #{@game.vital_label('health')} is 0. You win!</span>"
    elsif @game.player_who_surrendered == @game.player(user)
      erb "<span style='color: red;'>You surrendered. You lose!</span>"
    elsif @game.player_who_surrendered == @game.opponent(user)
        erb "<span style='color: green;'>Your opponent surrendered. You win!</span>"
    end
  end
end

before do
  begin
    @mixup_ad = Nestful.get("http://serve.mixup.hapnic.com/#{ENV['MXIT_APP_NAME']}").body
  rescue
    @mixup_ad = 'Nothing to see here for now'    
  end
end

get '/' do
  if user
    @active_games = user.games(:active => true)
    erb :home
  else
    redirect to '/new-user'
  end
end

get '/new-user' do
  erb :new_user, :layout => nil
end

post '/new-user' do
  if params[:username] =~ /^[a-zA-Z0-9]+$/
    unless User.first(:username => params[:username])
      mxit_user = MxitUser.new(request.env)
      User.create(:mxit_user_id => mxit_user.user_id, :username => params[:username])
      redirect to '/'
    else
      erb "Sorry, that name is already taken. <a href='#{url('/new-user')}'>Choose another one</a>", :layout => nil
    end
  else
     erb "Your name cannot contain special characters or spaces. <a href='#{url('/new-user')}'>Try again</a>", :layout => nil
  end  
end

get '/new-game-vs-player' do #I'll have to do something with this route...
  if user.games(:active => true).size < 3
    random_user_in_lobby = User.all(:in_lobby => true).sample
    user.update(:in_lobby => true)
    if random_user_in_lobby && random_user_in_lobby != user
      game_creator = GameCreator.new
      game = game_creator.new_game(user, random_user_in_lobby, game_config_file_path)
      user.update(:in_lobby => false)
      random_user_in_lobby.update(:in_lobby => false)
      redirect to "/game/#{game.id}"
    else
      erb "There are currently no available opponents. Please <a href='/'>try again</a> in a minute or so."
    end
  else
    erb "Sorry, you've reached the maximum number of simultaneous games."
  end
end

get '/new-game-vs-friend' do
  erb :friend_username
end

post '/new-game-vs-friend' do
  if user.games.size < 3
    friend = User.first(:username => params[:username])
    if friend && friend != user
      game_creator = GameCreator.new
      game = game_creator.new_game(user, random_user_in_lobby, game_config_file_path)
      redirect to "/game/#{game.id}"
    else
      erb "Sorry, we couldn't find that friend."
    end
  else
    erb "Sorry, you've reached the maximum number of simultaneous games. Finish some of them first."
  end
end

get '/game/:game_id' do
  @game = Game.get(params[:game_id])
  if @game.over?
    @game.end_game
    game_over_message
  else
    erb :board
  end
end

get '/game/:game_id/play/:hand_index' do
  game = Game.get(params[:game_id])
  player, opponent = game.player(user), game.opponent(user)
  card = player.hand[params[:hand_index].to_i]
  player.play_card(card, player, opponent)
  player.discard_card(card)
  player.draw_card
  player.last_move = "played <strong>#{card.name}: #{game.card_text(card)} (#{card.cost.to_s + game.vital_label(card.cost_type)[0].downcase})</strong>"
  game.end_turn
  redirect to "/game/#{params[:game_id]}"
end

get '/game/:game_id/discard/:hand_index' do
  game = Game.get(params[:game_id])
  player, opponent = game.player(user), game.opponent(user)
  card = player.hand[params[:hand_index].to_i]
  player.discard_card(card)
  player.draw_card
  player.last_move = "discarded <strong>#{card.name}: #{game.card_text(card)} (#{card.cost.to_s + game.vital_label(card.cost_type)[0].downcase})</strong>"
  game.end_turn  
  redirect to "/game/#{params[:game_id]}"
end

get '/game/:game_id/confirm-surrender' do
  erb 'Are you sure you want to surrender this game (your opponent will win)? <br /> <p><a href=<%= url("/game/#{params[:game_id]}/surrender") %>>Yes</a></p> <p><a href=<%= url("/game/#{params[:game_id]}") %>>No</a>'
end

get '/game/:game_id/surrender' do
  game = Game.get(params[:game_id])
  player, opponent = game.player(user), game.opponent(user)
  player.surrender = true
  game.save_game([player, opponent])
  redirect to "/game/#{params[:game_id]}"
end

get '/scores' do
  erb :scores
end

get '/stats' do
  erb "Users: #{User.all.count} <br /> Active games: #{Game.all(:active => true).size} <br /> Inactive games: #{Game.all(:active => false).size}"
end