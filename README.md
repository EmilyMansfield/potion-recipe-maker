potion-recipe-maker
===================

Randomly generate potion recipes for tabletop roleplaying games. Generates recipes such as

    - 28 g of Dragon Salt
    - 20 ml of Gnoll Spit
    - 24 g of Nightmare Skin
    - 6 Spider Teeth
    - 50 ml of Titan Extract

You can also guarantee that a given set of creature types will appear in the potion; Potions of Dragon Control should contain something from a dragon for example.

Data Files
==========

Combines the name of a creature from `creatures.txt` with a body part/ingredient type from `creatureParts.txt`. Syntax for `creatures.txt` is

    creature_name:  rarity
  
where `rarity` takes the value `common`, `uncommon`, `rare`, or `very_rare`. Rarity is weighted according to powers of 2, so `rare` is twice as likely to occur as `very_rare` and 4 times as unlikely to occur as `common`.

Syntax for `creatureParts.txt` is

    part: property1 property2 property3 ...
  
where each property is on the same line and separated by whitespace. Currently there are only 4 recognised properties that should not be used together; `solid`, `countable`, `fluid`, and `gaseous`. `solid`s are measured in grams (g), `fluid`s are measured in millilitres (ml), and `countable` and `gaseous` are just a number or 'some', respectively.

Guaranteeing Creatures
======================

Creatures can be guaranteed to occur by entering a comma separated list of them when prompted

    How many ingredients?
    3
    Specific creatures to include?
    Cow, Dragon, Wolf
     - some Wolf Scent
     - 100 ml of Dragon Bile
     - 60 ml of Cow Bile

The whitespace is irrelevant, so `Cow, Dragon` is the same as `Cow,Dragon`.
