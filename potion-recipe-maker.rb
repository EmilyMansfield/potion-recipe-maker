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

parts = IO.readlines('data/creatureParts.txt')

parts.map! do |x|
	partition = x.to_s.partition(/:\s*/)
	CreaturePart.new(partition[0], partition[2].chomp)
end

creatures = IO.readlines('data/creatures.txt')

creatures.map! do |x|
	partition = x.to_s.partition(/:\s*/)
	Creature.new(partition[0], partition[2].chomp)
end

rarity_hash = { 'common' => 8.0, 'uncommon' => 4.0, 'rare' => 2.0, 'very rare' => 1.0 }
cumulative_rarity = []
creatures.each do |x|
	cumulative_rarity.push rarity_hash[x.rarity]
end
sum = 0.0
cumulative_rarity.map! do |x|
	sum += x
end
cumulative_rarity.map! do |x|
	x / sum
end

puts "How many ingredients?"
num_ingredients = gets.chomp.to_i
puts "Specific creatures to include?"
include_creatures = gets.chomp.to_s.split(/,\s*/)

prng = Random.new

(1..num_ingredients).each do |x|
	index = prng.rand(1.0)
	unless include_creatures.empty?
		creature = creatures.find { |x| x.name == include_creatures.last }
		include_creatures.pop
	else
		creature = creatures[cumulative_rarity.find_index { |y| y > index }]
	end

	part = parts.sample
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
	puts " - #{amount} #{unit}#{creature.name} #{part.name}"
end
