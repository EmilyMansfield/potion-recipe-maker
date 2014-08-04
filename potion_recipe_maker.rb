require_relative 'recipe_book.rb'

$recipe_book = RecipeBook.new

puts "How many ingredients?"
$num_ingredients = gets.chomp.to_i
puts "Specific creatures to include?"
$included_creatures = gets.chomp.to_s.split(/,\s*/)

recipe = $recipe_book.make_recipe($num_ingredients, $included_creatures)

recipe.each { |x| puts x }