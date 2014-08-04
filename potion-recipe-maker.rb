class CreaturePart
  attr_reader :name, :properties

  def initialize(name, properties)
    @name = name
    @properties = properties
  end
end

class Creature
  attr_reader :name, :rarity

  def initialize(name, rarity)
    @name = name
    @rarity = rarity
  end
end

class RecipeBook
  private
 
  def build_cumulative_rarity
    rarity_hash = { 'common' => 8.0, 'uncommon' => 4.0, 'rare' => 2.0, 'very rare' => 1.0 }
    @cumulative_rarity = []
    @creatures.each { |x| @cumulative_rarity << rarity_hash[x.rarity] }
    sum = 0.0
    @cumulative_rarity.map! { |x| sum += x }
    @cumulative_rarity.map! { |x| x / sum }
  end
  
  public
  
  def initialize
    @parts = IO.readlines('data/creatureParts.txt')
    @parts.map! do |x|
      partition = x.to_s.partition(/:\s*/)
      CreaturePart.new(partition[0], partition[2].chomp)
    end
    
    @creatures = IO.readlines('data/creatures.txt')
    @creatures.map! do |x|
      partition = x.to_s.partition(/:\s*/)
      Creature.new(partition[0], partition[2].chomp)
    end
    build_cumulative_rarity
  end

  
  def make_recipe(num_ingredients, included_creatures=[])
    prng = Random.new
    recipe = []
    (1..num_ingredients).each do |x|
      index = prng.rand(1.0)
      unless included_creatures.empty?
        creature = @creatures.find { |x| x.name == included_creatures.last }
        included_creatures.pop
      else
        creature = @creatures[@cumulative_rarity.find_index { |y| y > index }]
      end

      part = @parts.sample
      amount = 5
      unit = 'g'
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
end

$recipe_book = RecipeBook.new

puts "How many ingredients?"
$num_ingredients = gets.chomp.to_i
puts "Specific creatures to include?"
$included_creatures = gets.chomp.to_s.split(/,\s*/)

recipe = $recipe_book.make_recipe($num_ingredients, $included_creatures)

recipe.each { |x| puts x }