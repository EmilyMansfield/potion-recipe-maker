require 'fox16'
require_relative 'recipe_book'
include Fox

class PotionRecipeGenerator < FXMainWindow
  def initialize(app)
    super(app, 'Potion Recipe Generator', width: 400, height: 400)
    @ingredients_frame = FXHorizontalFrame.new(self)
    @ingredients_label = FXLabel.new(@ingredients_frame, 'Number of ingredients: ')
    ingredients_text_opts = TEXTFIELD_INTEGER | TEXTFIELD_ENTER_ONLY | FRAME_SUNKEN | FRAME_THICK
    @ingredients_text = FXTextField.new(@ingredients_frame, 8, opts: ingredients_text_opts)
    @ingredients_text.justify = JUSTIFY_RIGHT
    
    @creatures_frame = FXHorizontalFrame.new(self, opts: LAYOUT_FILL_X)
    @creatures_label = FXLabel.new(@creatures_frame, 'Include ingredients from: ')
    @creatures_list = FXList.new(@creatures_frame, opts: LAYOUT_FILL_X | LIST_MULTIPLESELECT)
    @creatures_list.numVisible = 8
    
    @recipe_frame = FXVerticalFrame.new(self, opts: LAYOUT_FILL )
    @recipe_text = FXText.new(@recipe_frame, opts: LAYOUT_FILL | TEXT_READONLY)
    
    @generate_frame = FXHorizontalFrame.new(@recipe_frame)
    @generate_button = FXButton.new(@generate_frame, 'Generate Recipe')
    
    @generate_button.connect(SEL_COMMAND) do |_sender, _selector, _data|
      new_recipe
    end
    
    @ingredients_text.connect(SEL_COMMAND) do |_sender, _selector, _data|
      new_recipe
    end
    
    @recipe_book = RecipeBook.new

    @creatures_list.fillItems(@recipe_book.creature_names)
  end
  
  def create
    super
    show(PLACEMENT_SCREEN)
  end
  
  def new_recipe
    include_creatures = []
    @creatures_list.each { |x| include_creatures << x.text if x.selected?}
    
    recipe = @recipe_book.make_recipe(@ingredients_text.text.to_i, include_creatures)
    @recipe_text.removeText(0, @recipe_text.length)
    recipe.each { |x| @recipe_text.appendText("#{x}\n") }
  end
end

FXApp.new do |app|
  PotionRecipeGenerator.new(app)
  app.create
  app.run
end