require 'json'

class Spell

  def initialize(params)
    @classification = params["Classification"]
    @effect = params["Effect"]
    @name = params["Spell(Lower)"]
    @formatted_name = params["Spell"]
  end

  attr_reader :classification, :effect, :name, :formatted_name

  def self.data
    path = 'data/spells.json'
    file = File.read(path)
    JSON.parse(file)
  end

  def self.random
    new(data.sample)
  end

  # allows me to access the name as a string
  def name
    @name
  end

  def formatted_name
    @formatted_name
  end

  def self.effects
    data.map{|el| el["Effect"]}
  end

  # These two methods are used to validate answers
  def self.is_spell_name?(str)
    data.index { |el| el["Spell(Lower)"] == (str.downcase) }
  end

  def self.is_spell_name_for_effect?(name, effect)
    data.index { |el| el["Spell(Lower)"] == name && el["Effect"] == effect }
  end

  # To get access to the collaborative repository, complete the methods below.

  # Spell 1: Reverse
  # This instance method should return the reversed name of a spell
  # Tests: `bundle exec rspec -t reverse .`
  def reverse_name
    name.reverse
  end

  # Spell 2: Counter
  # This instance method should return the number
  # (integer) of mentions of the spell.
  # Tests: `bundle exec rspec -t counter .`
  def mention_count
    mentions = Mention.data
    spell_count = 0

    # for each object in mentions array
    mentions.each {|i|
      # Test Feature
      # puts i["Spell"]
      # puts "-----------"
      # puts self.name

      # if each hash key("Spell")'s value == spell's name
      if i["Spell"] == self.name
        spell_count += 1
      end
    }
    # Test Feature
    # puts spell_count
    spell_count
  end

  # Spell 3: Letter
  # This instance method should return an array of all spell names
  # which start with the same first letter as the spell's name
  # Tests: `bundle exec rspec -t letter .`
  def names_with_same_first_letter
    first_letter = self.name[0].downcase
    spells = Spell.data
    same_1st_ltr = Set.new

    spells.each {|i|
      # puts "******Before Test Output******"
      # puts i["Spell(Lower)"]
      # puts i["Spell(Lower)"][0]
      # puts "****** Before Test Output******"

      if i["Spell(Lower)"][0] == first_letter
        same_1st_ltr.add(i["Spell(Lower)"])
      end
    }
    # Test Feature
    # puts set_same_1st_ltr
    # puts first_letter
    # Test Feature

    # converts the set to an array
    same_1st_ltr.to_a
  end

  # Spell 4: Lookup
  # This class method takes a Mention object and
  # returns a Spell object with the same name.
  # If none are found it should return nil.
  # Tests: `bundle exec rspec -t lookup .`
  def self.find_by_mention(mention)
    spell_name = mention.name
    classification = nil
    effect = nil
    spell_lower = nil
    spell = nil
    spells = Spell.data

    spells.each {|i|
      if i["Spell(Lower)"] == spell_name
        classification = i["Classification"]
        effect = i["Effect"]
        spell_lower = spell_name.downcase
        spell = spell_name.capitalize
      end
    }
    return unless spell != nil
      Spell.new({"Classification" => classification,
               "Effect" => effect,
               "Spell(Lower)" => spell_lower,
               "Spell" => spell})
  end

end
