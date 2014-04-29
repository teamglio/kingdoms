module Effect
  # Player effects
  def increase_health(player, amount)
    unless player.health + amount > 100
      player.health += amount
    else
      player.health = 100
    end
  end

  def decrease_health(player, amount)
    unless player.health - amount < 0
      player.health -= amount
    else
      player.health = 0
    end
  end

  def increase_defence(player, amount)
    player.defence += amount
  end

  def decrease_defence(player, amount)
    player.defence -= amount
  end

  def decrease_health_and_defence(player, amount)
    if player.defence > 0
      if amount > (player.defence + player.health)
        player.defence = 0
        player.health = 0
      elsif amount > player.defence
        player.health -= amount - player.defence
        player.defence = 0
      elsif amount < player.defence
        player.defence -= amount
      end
    elsif player.defence == 0
      if amount < player.health
        player.health -= amount
      elsif amount > player.health
        player.health = 0
      end
    end
  end

  # Store effects

  def increase_stock(type, player, amount)
    raise "Should be matter, energy or intelligence" unless ['matter', 'energy', 'intelligence'].include?(type)
    case type
    when 'matter'
      player.matter += amount
    when 'energy'
      player.energy += amount
    when 'intelligence'
      player.intelligence += amount
    end
  end

  def decrease_stock(type, player, amount)
    raise "Should be matter, energy or intelligence" unless ['matter', 'energy', 'intelligence'].include?(type)
    case type
    when 'matter'
      player.matter = player.matter - amount >= 0 ? player.matter -= amount : 0
    when 'energy'
      player.energy = player.energy - amount >= 0 ? player.energy -= amount : 0
    when 'intelligence'
      player.intelligence = player.intelligence - amount >= 0 ? player.intelligence -= amount : 0
    end
  end

  def increase_rate(type, player, amount)
    raise "Should be matter, energy or intelligence" unless ['matter', 'energy', 'intelligence'].include?(type)
    case type
    when 'matter'
      player.matter_rate += amount
    when 'energy'
      player.energy_rate += amount
    when 'intelligence'
      player.intelligence_rate += amount
    end
  end

  def decrease_rate(type, player, amount)
    raise "Should be matter, energy or intelligence" unless ['matter', 'energy', 'intelligence'].include?(type)
    case type
    when 'matter'
      player.matter_rate = player.matter_rate - amount >= 0 ? player.matter_rate -= amount : 0
    when 'energy'
      player.energy_rate = player.energy_rate - amount >= 0 ? player.energy_rate -= amount : 0
    when 'intelligence'
      player.intelligence_rate = player.intelligence_rate - amount >= 0 ? player.intelligence_rate -= amount : 0
    end
  end
end