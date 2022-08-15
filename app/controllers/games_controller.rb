require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @word = params[:input].split('')
    # pass @letters to this method
    @letters = params[:letters]
    @word = params[:input]
    # check all letters in @word are present in @letters
    if check_word_valid?(@word, @letters)
      # check if word is valid with api
      api_response = word_exists?(@word)
      @round_score = api_response[:score] || 0
      # update session score
      session[:score] += @round_score
      @overall_score = session[:score]
      @result = api_response[:valid] ? "Congratulations! #{@word} is a valid English word!" : "Sorry but #{@word} doesn't seem to be a valid word..."
    else
      @result = "Sorry, but #{@word} can't be built out of #{@letters}"
    end
    #if word valid calc score

  end

  def check_word_valid?(word, letters)
    # convert letters from string to array
    letters = letters.chars
    # iterate over all characters in word selecting only those present in letters
    test_arr = word.chars.select do |letter|
      # check that letters includes this letter
      if letters.include?(letter.upcase)
        letters.delete_at(letters.index(letter.upcase))
        letter
      else
        # if letter doesn't exit skip to next iteration
        next
      end
    end
    # return true/false for all chars in word present in letters
    test_arr == word.chars
  end

  def word_exists?(word)
    # call dictionary api
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response_serialized = URI.open(url).read
    data = JSON.parse(response_serialized)
    { valid: data['found'], score: data['length'] }
  end
end
