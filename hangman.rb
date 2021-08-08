require_relative "game"
require_relative "color"
require 'yaml'


def start_game
  puts "\nLet's play hangman in the console! Would you like to: \n[1] Start a new game \n[2] Load a saved game"
  player_choice = gets.chomp
  if player_choice == "1"
    game = Game.new
    if game.play_game == 'save'
      save_game(game)
    end
  elsif player_choice == "2"
    x = load_game
    x.play_game
  else
    puts "\nWrong input!"
    start_game
  end
end


def save_game(current_game)
  filename = prompt_name
  return false unless filename
  dump = YAML.dump(current_game)
  File.open(File.join(Dir.pwd, "/saved/#{filename}.yaml"), 'w') { |file| file.write dump }
end


def prompt_name
  begin
    filenames = Dir.glob('saved/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))]}
    puts "Enter name for saved game"
    filename = gets.chomp
    raise "#{filename} already exists." if filenames.include?(filename)
    filename
  rescue StandardError => e
    puts "#{e} Are you sure you want to rewrite the file? (Yes/No)".red
    answer = gets[0].downcase
    until answer == 'y' || answer == 'n'
      puts "Invalid input. #{e} Are you sure you want to rewrite the file? (Yes/No)".red
      answer = gets[0].downcase
    end
    answer == 'y' ? filename : nil
  end
end


def load_game
  filename = choose_game
  saved = File.open(File.join(Dir.pwd, filename), 'r')
  loaded_game = YAML.unsafe_load(saved)
  saved.close
  loaded_game
end


def choose_game
  begin
    puts "Here are the current saved games. Please choose which you'd like to load."
    filenames = Dir.glob('saved/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
    puts filenames
    filename = gets.chomp
    raise "#{filename} does not exist.".red unless filenames.include?(filename)
    puts "#{filename} loaded..."
    "/saved/#{filename}.yaml"
  rescue StandardError => e
    puts e
    retry
  end
end

start_game
