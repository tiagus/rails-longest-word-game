class GamesController < ApplicationController
  def new
    vowels = %w[A E I O U]
    chars = Array.new(5) { ('A'..'Z').to_a.sample }
    @letters = (vowels + chars).shuffle
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || '').upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    word.chars.all? do |letter|
      word.count(letter) <= letters.count(letter)
    end
  end

  def english_word?(word)
    response = RestClient.get("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.body, symbolize_names: true)
    json[:found]
  end
end
