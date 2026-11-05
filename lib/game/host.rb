# frozen_string_literal: true

require_relative 'hangable'

# This represents the "executioner" in charge — the computer in this case. It'll
# choose the secret word and act on the player's guess to update the paper and
# confirm when they've guessed the whole secret word (or do nothing at all when
# a guess is incorrect).
class Host
  include Hangable

  attr_reader :player_misses

  def initialize(paper, player)
    @paper = paper
    @player = player
    @secret_word = ''
    @blanks = []
    @player_misses = []
  end

  def sanitize(dictionary)
    dictionary.each_index do |i|
      dictionary[i] = dictionary[i].chomp
    end
  end

  def read_dictionary
    dictionary = []

    File.open('google-10000-english-no-swears.txt') do |file|
      dictionary = file.readlines
    end

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

    @secret_word.each_char { |_letter| @blanks << '_' }

    update_paper
  end

  def word_guessed?
    @blanks.join.eql? @secret_word
  end

  def correct
    @secret_word.each_char.with_index do |letter, index|
      @blanks[index] = letter if letter.eql? @player.guess
    end

    @player.correct_guess = true

    update_paper

    @player.won = true if word_guessed?
  end

  def incorrect
    @player_misses << @player.guess

    @player.correct_guess = false

    @player.misses_left -= 1
  end

  def give_feedback
    @secret_word.include?(@player.guess) ? correct : incorrect
  end

  def show_misses
    puts "(MISSES: #{@player_misses.join(', ')})\n\n"
  end

  def draw_stick_figure(stage)
    puts stick_figure(stage.to_s)
  end

  def reveal_word
    puts "The word was #{@secret_word.upcase}."
  end

  def reset
    @blanks = []
    @player_misses = []
  end
end
