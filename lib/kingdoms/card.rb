#refactor inheritance and initialize methods

#affect(me, opponent)
class Card
  include Effect

  attr_reader :name, :effect, :cost, :cost_type

  def initialize(name, effect, cost, cost_type)
    @name = name
    @effect = effect    
    @cost = cost
    @cost_type = cost_type
  end
end

# Health cards

class Healer < Card
  def affect(me, opponent)
    increase_health(me, @effect)
  end
end

class Poisoner < Card
  def affect(me, opponent)
    decrease_health(opponent, @effect)
  end  
end

class Leech < Card
  def affect(me, opponent)
    decrease_health(opponent, @effect)
    increase_health(me, @effect)
  end    
end

# Defence cards

class Defender < Card
  def affect(me, opponent)
    increase_defence(me, @effect)
  end
end

# Health-and-defence hybrid cards

class Reservist < Card
  def affect(me, opponent)
    decrease_defence(me, @effect)
    increase_health(me, @effect)
  end  
end

class Attacker < Card
  def affect(me, opponent)
    decrease_health_and_defence(opponent, @effect)
  end 
end

# Stock cards

class Destroyer < Card

  attr_reader :name, :effect, :effect_type, :cost, :cost_type

  def initialize(name, effect, effect_type, cost, cost_type)
    @name = name
    @effect = effect
    @effect_type = effect_type    
    @cost = cost    
    @cost_type = cost_type
  end

  def affect(me, opponent)
    decrease_stock(@effect_type, opponent, @effect)
  end  
end

class Stocker < Card

  attr_reader :name, :effect, :effect_type, :cost, :cost_type

  def initialize(name, effect, effect_type, cost, cost_type)
    @name = name
    @effect = effect
    @effect_type = effect_type    
    @cost = cost    
    @cost_type = cost_type
  end

  def affect(me, opponent)
    increase_stock(@effect_type, me, @effect)
  end  
end


class Saboteur < Card

  attr_reader :name, :effect, :cost, :cost_type

  def initialize(name, effect, cost, cost_type)
    @name = name
    @effect = effect
    @cost = cost    
    @cost_type = cost_type
  end

  def affect(me, opponent)
    ['matter', 'energy', 'intelligence'].each do |type|    
      decrease_stock(type, opponent, @effect)
    end
  end
end

class Thief < Card
  def affect(me, opponent)
    ['matter', 'energy', 'intelligence'].each do |type|
      decrease_stock(type, opponent, @effect)
      increase_stock(type, me, @effect)
    end
  end
end

# Rate cards

class Trainer < Card

attr_reader :name, :effect, :effect_type, :cost, :cost_type

  def initialize(name, effect, effect_type, cost, cost_type)
    @name = name
    @effect = effect
    @effect_type = effect_type    
    @cost = cost    
    @cost_type = cost_type
  end

  def affect(me, opponent)
    increase_rate(@effect_type, me, @effect)
  end  
end

class Underminer < Card
end

# Blanket cards

class Blanket < Card
  def affect(me, opponent)
    decrease_health(opponent, @effect)
    increase_health(me, @effect)
    decrease_defence(opponent, @effect)
    increase_defence(me, @effect)
    ['matter', 'energy', 'intelligence'].each do |type|
      decrease_stock(type, opponent, @effect)
      increase_stock(type, me, @effect)
      decrease_rate(type, opponent, @effect)
      increase_rate(type, me, @effect)      
    end    
  end    
end
