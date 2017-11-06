require 'open-uri'
require 'json'

class WordsController < ApplicationController

  def game
    @grid = generate_grid(10)
    @start_time = Time.now
  end

  def score
    @attempt = params[:clueless]
    grid = params[:grid_string].chars
    start_time = Time.parse(params[:start_time])
    end_time = Time.now
    @result = run_game(@attempt, grid, start_time, end_time)
    #update_session(@result)
    #@high_score = session[:high_score]
  end

=begin
  def update_session(result)
    if session[:high_score].nil? || session[:high_score] < result[:score]
      session[:high_score] = result[:score]
    end
  end
=end


  private

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0).round(2)
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: (end_time - start_time).round(2) }

    score_and_message = score_and_message(attempt, grid, result[:time])
    result[:score] = score_and_message.first
    result[:message] = score_and_message.last

    result
  end

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
