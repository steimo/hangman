class Game


  def initialize
    @secret_word = select_secret_word
    @right_guessed_letters = []
    @wrong_guessed_letters = []
    @message = "\nEnter a letter, or type 'save' to save progress:"
  end


  def select_secret_word 
    file = File.open("5desk.txt")
    file_data = file.readlines.map(&:chomp).select{ |word| 
      word == word.downcase && word.length > 5 && word.length < 12}
    file.close
    return file_data.sample
  end
  

  def check_the_input
      input = gets.chomp.downcase
      if input == 'save'
        return 'save'
      end
    if input.match?(/[[:alpha:]]/) && input.length < 2
      return input
    else
      puts "\nInvalid input: #{input}".red
      input = "" 
      puts @message
      input = gets.chomp.downcase
      check_the_input
  end
  end

  
  def check_the_guess(player_guess)
    if player_guess == 'save'
      return 'save'
    end
    if @right_guessed_letters.include? player_guess
      return puts "\nYou've already guessed this letter".red
    elsif @wrong_guessed_letters.include? player_guess
      return puts "\nYou've alredy gueseed this letter\n".red
    end
    if @secret_word.include? player_guess #&& right_guessed_letters.include? player_guess
      puts "Good guess!".green
      return true
    else
      puts "No luck!".cyan
      return false
    end
  end


  def show_blanks
    blanks = "_" * @secret_word.length
    for i in (0..@secret_word.length)
      if @right_guessed_letters.include?(@secret_word[i])
        blanks[i] = @secret_word[i]
      end
    end
    blanks.each_char {|l| print l + " "}
    puts "\nLetters guessed: #{@wrong_guessed_letters.uniq.join(",")}"
  end

  def player_won
   if @right_guessed_letters.length == @secret_word.split(//).uniq.length
      return true
    else
      false
    end
  end
  
  
  def display_count
    puts "Incorrect guesses remaining: #{10 - @wrong_guessed_letters.uniq.length}".brown
  end

  def play_game 
    puts "Your random word has been chosen, it has #{@secret_word.length} letters:"
    show_blanks
    while @wrong_guessed_letters.uniq.length < 10 do
      puts @message
      player_guess = check_the_input
      if player_guess == 'save'
        return 'save'
      end
      if check_the_guess(player_guess)
        @right_guessed_letters.push player_guess
      else
        @wrong_guessed_letters.push player_guess
      end
      if player_won
        return puts "\nYou guessed the word! \n#{@secret_word}".magenta.blink
      end
      show_blanks
      display_count
      if @wrong_guessed_letters.uniq.length == 10 
        return puts "You couldn't guess the word! \n#{@secret_word}".blink
      end
    end
  end
end
