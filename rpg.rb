class Creature

	DEFAULT_ATTRIBUTES = {
		health: 100,
		damage: 15,
		crit_chance: 0.1,
		miss_chance: 0.02,
		evansion: 0.05,

		# hidden_attributes
		# traveller_skill: 0.05
	}

	DEFAULT_ENEMY_ATTRIBUTES = {
		health: 60,
		damage: 15,
		crit_chance: 0.1,
		miss_chance: 0.03,
		evansion: 0.07,

		# hidden_attributes
	}

	AVAILABLE_RACES = {
		human: {
			health: 0,
			damage: 0,
			crit_chance: 0,
			miss_chance: 0,
			evansion: 0
		},

		orc: {
			health: 10,
			damage: 5,
			crit_chance: -0.09,
			miss_chance: 0.02,
			evansion: -0.05
		},

		elf: {
			health: -10,
			damage: -5,
			crit_chance: 0.075,
			miss_chance: -0.01,
			evansion: 0.05
		}
	}

	ENEMIES_RACES = {
		troll: {
			health: 30,
			damage: 10,
			crit_chance: 0,
			miss_chance: 0.04,
			evansion: 0
		},

		goblin: {
			health: 0,
			damage: 0,
			crit_chance: 0.12,
			miss_chance: 0,
			evansion: 0.05
		},

		giant: {
			health: 55,
			damage: 15,
			crit_chance: -0.2,
			miss_chance: 0.05,
			evansion: -0.1
		}
	}

	AVAILABLE_CLASSES = {
		warrior: {
			health: 20,
			damage: 5,
			crit_chance: 0,
			evansion: 0
		},

		ranger: {
			health: 10,
			damage: 5,
			crit_chance: 0.075,
			evansion: 0.05
		},

		mage: {
			health: 0,
			damage: 10,
			crit_chance: 0,
			evansion: 0.05
		}
	}

	PLACES_ENEMIES_ELEMENTS = {
		'highland' => {
				earth: 70,
				fire: 25,
				ice: 5
			},
		'volcano' => {
				fire: 75,
				earth: 25
			},
		'frost cave' => {
				ice: 75,
				earth: 25
			}
	}

	ELEMENTS_MODIFICATORS = {
		earth: {
				health: 30,
				damage: 0,
				crit_chance: 0,
				miss_chance: 0,
				evansion: 0
			},
		fire: {
				health: -15,
				damage: 5,
				crit_chance: 0.15,
				miss_chance: 0.1,
				evansion: 0.1
			},
		ice: {
				health: 10,
				damage: 10,
				crit_chance: 0,
				miss_chance: 0,
				evansion: 0.05
			}
	}

	PLACES_ENEMIES = {
		'highland' => {
				troll: 25,
				goblin: 65,
				giant: 10
			},
		'volcano' => {
				troll: 35,
				goblin: 45,
				giant: 15
			},
		'frost cave' => {
				troll: 45,
				goblin: 45,
				giant: 10
			}
	}

	# modificators
	attr_reader :race
	attr_reader :class

	# attributes
	attr_reader :health
	attr_reader :damage
	attr_reader :miss_chance
	attr_reader :crit_chance
	attr_reader :evansion

	# hidden_attributes
	# attr_reader :traveller_skill

	# =====================

	def initialize(p_race, p_class, enemy = false)
		if !enemy
			creature_attributes = DEFAULT_ATTRIBUTES
			race_attributes = AVAILABLE_RACES[p_race]
			class_attributes = AVAILABLE_CLASSES[p_class]
		else
			# enemy
			creature_attributes = DEFAULT_ENEMY_ATTRIBUTES
			race_attributes = ENEMIES_RACES[p_race]
			class_attributes = ELEMENTS_MODIFICATORS[p_class]
		end

		race_attributes.each do |atr, value|
			creature_attributes[atr] += value
		end
		class_attributes.each do |atr, value|
			creature_attributes[atr] += value
		end
		@race = p_race
		@class = p_class

		@health = creature_attributes[:health]
		@damage = creature_attributes[:damage]
		@miss_chance = creature_attributes[:miss_chance]
		@crit_chance = creature_attributes[:crit_chance]
		@evansion = creature_attributes[:evansion]
		@health_limit = @health
	end

	def show_attributes
		puts "Stats of #{@class} #{@race}"
		puts "Current attributes:"
		puts "> health       =>  #{health}"
		puts "> damage       =>  #{damage}"
		puts "> miss_chance  =>  #{procentage(miss_chance)}%"
		puts "> crit_chance  =>  #{procentage(crit_chance)}%"
		puts "> evansion     =>  #{procentage(evansion)}%"
		puts
	end

	def take_rest
		puts "*"
		puts "Never better than a good nap."
		puts "*"
		@health = @health_limit
	end

	private



	def procentage(value)
		if value.class != Float
			raise "#{value} - this value is not Float"
		end
		return (value*100).round(1)
	end

end

class Game
	$races = Creature::AVAILABLE_RACES
	$classes = Creature::AVAILABLE_CLASSES
	$places = Creature::PLACES_ENEMIES_ELEMENTS
	$enemies = Creature::PLACES_ENEMIES

	GLOBAL_ACTIONS = {
		"Show attributes" => :show_attributes,
		"Show stat" => :show_stat,
		"Rest" => :take_rest,
		"Travell" => :travell
	}

	attr_accessor :player
	attr_accessor :day

	def initialize()
		@day = 1
	end

	def game
		greetings()
		p_race = pick_race()
		puts "p_race: #{p_race}"
		p_class = pick_class()
		puts "p_class: #{p_class}"
		p_race, p_class = confirm_hero(p_race, p_class)
		@player = Creature.new(p_race, p_class)
		game_loop()
	end

	private

	def days_passed(days)
		if days >= 0
			@day += days
		else
			raise 'Count of passed days cant < 0'
		end
	end

	def game_loop
		while true
			puts
			puts "==============="
			puts "====Day ##{@day}===="
			puts "==============="
			str = "What do you want to do now?"
			puts str

			action_key = choose_key_option(GLOBAL_ACTIONS.keys)
			action_key = GLOBAL_ACTIONS.keys[action_key]
			action = GLOBAL_ACTIONS[action_key]
			if action == :show_attributes
				@player.show_attributes
			elsif action == :show_stat
				@player.show_stat
			elsif action == :take_rest
				@player.take_rest
				days_passed(1)
			elsif action == :travell
				enemy = travell()
				enemy.show_attributes
			end

			puts
			gets

		end
	end

	def travell
		puts "Where will you go?"
		puts

		place_key = choose_key_option($places.keys)
		place = $places.keys[place_key]

		random_element = $places[place].take_element

		enemies_in_place = $enemies[place]
		enemy = enemies_in_place.take_element

		puts "You meet the #{random_element.capitalize} #{enemy.capitalize}"
		return enemy = Creature.new(enemy, random_element, true)
	end

	def greetings
		str = "
		Hello, stranger!

		Novaldia is dangerous place and you'll need a
		strong will or flexible abilities for
		conquer these lands.

		It's time to begin you jorney, so, first of all
		you'll need to create your hero.

		=======================
		"
		puts str
	end

	def pick_race
		str = "Choose your race:"
		puts str
		race = choose_key_option($races.keys)

		return $races.keys[race]
	end

	def pick_class
		str = "Choose your class:"
		puts str

		chosen_class = choose_key_option($classes.keys)

		return $classes.keys[chosen_class]
	end

	def confirm_hero(p_race, p_class)
		while true
			str = "
			You now #{p_race.capitalize} #{p_class.capitalize} !

			Do you agree with it or not?
			0 => I'm agree!
			1 => Switch race
			2 => Switch class
			"
			puts str

			answer = gets.to_i
			puts "your answer: #{answer}"

			if answer == 1
				p_race = pick_race()
			elsif answer == 2
				p_class = pick_class()
			else
				return [p_race, p_class]
			end
		end
	end

end



# Helpers

def choose_key_option(sourse)
	max_index = sourse.size - 1
	answer = nil
	until answer && (answer <= max_index && answer >= 0)
		sourse.each_with_index do |src_item, i|
			puts "#{i} => #{src_item.capitalize}"
		end

		answer = gets.to_i
		puts
	end

	puts "#{sourse[answer].capitalize} choosen."
	puts "======================="
	puts

	return answer
end

class Hash
	def take_element
		hsh =	{}
		current_limit = 0
		self.each do |key, value|
			hsh[key] = current_limit...(value+current_limit)
			current_limit += value
		end

		random_value = rand(0...current_limit)
		hsh.each do |key, range|
			next if !range.include?(random_value)
			return key
		end
	end
end


g = Game.new().game()
