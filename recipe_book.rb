class CreaturePart
  attr_reader :name, :properties

  def initialize(name, properties)
    @name = name
    @properties = properties.split
  end
end

class Creature
  attr_reader :name, :rarity, :properties

  def initialize(name, rarity, properties = [])
    @name = name
    @rarity = rarity
    @properties = properties
  end
end

class RecipeBook
  def initialize
    @parts = IO.readlines('data/creatureParts.txt')
    @parts.map! do |x|
      partition = x.to_s.partition(/:\s*/)
      name = partition[0]
      properties = partition[2].split
      CreaturePart.new(name, properties)
    end
    
    @creatures = IO.readlines('data/creatures.txt')
    @creatures.map! do |x|
      partition = x.to_s.partition(/:\s*/)
      name = partition[0]
      properties = partition[2].split
      rarity = properties.find { |x| x == 'common' || x == 'uncommon' || x == 'rare' || x == 'very_rare' }
      Creature.new(name, rarity, properties)
    end
    
    build_cumulative_rarity
  end

  def make_recipe(num_ingredients, included_creatures=[])
    prng = Random.new
    recipe = []
    (1..num_ingredients).each do |x|
      index = prng.rand(1.0)
      if included_creatures.empty?
        creature = @creatures[@cumulative_rarity.find_index { |y| y > index }]
      else
        creature = @creatures.find { |x| x.name == included_creatures.last }
        included_creatures.pop
      end

      part = @parts.sample
      amount = 5
      unit = 'g of '
      if part.properties.include? 'gaseous'
        unit = ''
        amount = 'some'
      elsif part.properties.include? 'fluid'
        unit = 'ml of '
        amount = prng.rand(1..10) * 10
      elsif part.properties.include? 'countable'
        unit = ''
        amount = prng.rand(1..10)
      elsif part.properties.include? 'solid'
        unit = 'g of '
        amount = prng.rand(5..30)
      end
      recipe << " - #{amount} #{unit}#{creature.name} #{part.name}"
    end
    recipe
  end
  
  def creature_names
    @creatures.map { |x| x.name }
  end
  
  private
 
  def build_cumulative_rarity
    rarity_hash = { common: 8.0, uncommon: 4.0, rare: 2.0, very_rare: 1.0 }
    @cumulative_rarity = []
    @creatures.each { |x| @cumulative_rarity << rarity_hash[x.rarity.intern] }
    sum = 0.0
    @cumulative_rarity.map! { |x| sum += x }
    @cumulative_rarity.map! { |x| x / sum }
  end
end