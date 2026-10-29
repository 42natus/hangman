# frozen_string_literal: true

# This represents the "executioner" in charge — the computer in this case. It'll
# choose the secret word and act on the player's guess to update the paper and
# confirm when they've guessed the whole secret word (or do nothing at all when
# a guess is incorrect).
class Host
  def initialize(paper, player)
    @paper = paper
    @player = player
    @secret_word = ''
    @blanks = []
  end

  def sanitize(dictionary)
    dictionary.each_index do |i|
      dictionary[i] = dictionary[i].chomp
    end
  end

  def read_dictionary
    file = File.open('google-10000-english-no-swears.txt')

    dictionary = file.readlines

    file.close

    sanitize(dictionary)
  end

  def update_paper
    @paper.secret_letters = @blanks
  end

  def choose_secret_word
    dictionary = read_dictionary

    word = ''

    word = dictionary[rand(dictionary.length)] until word.length.between?(5, 12)

    @secret_word = word

    @secret_word.each_char { |letter| @blanks << '_' }

    update_paper
  end

  def word_guessed?
    @blanks.join.eql? @secret_word
  end

  def give_feedback
    # binding.pry

    return unless @secret_word.include? @player.guess

    @secret_word.each_char.with_index do |letter, index|
      @blanks[index] = letter if letter.eql? @player.guess
    end

    update_paper

    @player.won = true if word_guessed?
  end

  def show_guesses_remaining
    puts ''

    if @player.guesses_left == 1
      puts "1 GUESS LEFT\n"
    else
      puts "#{@player.guesses_left} GUESSES LEFT\n"
    end
  end

  def reveal_word
    puts "The word was #{@secret_word.upcase}."
  end

  def reset
    @blanks = []
  end
end
