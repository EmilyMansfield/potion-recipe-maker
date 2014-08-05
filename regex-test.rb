$data = "Cyclops: rare [Eyes Teeth]"

tokens = $data.match(/(?<name>\w+):\s*(?<rarity>\w+)\s+(?:(?<blacklist>!)?\[(?<items>.*?)\])?\n?/)
puts "Name = #{tokens['name']}"
puts "Rarity = #{tokens['rarity']}"
puts "Blacklist? #{tokens['blacklist'] ? 'Yes' : 'No'}"
items = tokens['items'].split
puts "Items = #{items}"