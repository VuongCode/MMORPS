require "sinatra"
require 'pry'

use Rack::Session::Cookie, {
  secret: "shut_it",
  expire_after: 86400 # seconds
}

get "/" do
  erb :index, locals: { statement: session[:statement], human_score: session[:human_score], computer_score: session[:computer_score], winner: session[:winner]}
end

post "/" do
  human_choice = params[:choice]
  statement = play(human_choice)
  winner = nil
  if human_choice == "Play again" || human_choice == nil
    statement = ""
    session[:human_score] = 0
    session[:computer_score] = 0
  else
    if session[:human_score].nil? && session[:computer_score].nil?
      session[:human_score] = 0
      session[:computer_score] = 0
    elsif session[:human_score] == 2
      winner = "You win!"
      statement = ""
    elsif session[:computer_score] == 2
      winner = "You should play an easier game"
      statement = ""
    elsif statement.include?("Human wins")
      session[:human_score] += 1
    elsif statement.include?("Computer wins")
      session[:computer_score] += 1
    end
  end
  session[:winner] = winner
  session[:statement] = statement
  redirect "/"
end

def play(player_choice)
  statement = ""
  statement << "You chose #{player_choice}, "

  computer_choice = rand(3)
  case computer_choice
    when 0
      computer_choice = "Rock"
    when 1
      computer_choice = "Paper"
    else
      computer_choice = "Scissors"
  end
  statement << "computer chose #{computer_choice}. "

  if player_choice == computer_choice
    statement << "Tie, no winner."
  elsif player_choice == "rock" && computer_choice == "Paper"
    statement << "Computer wins this time."
  elsif player_choice == "rock" && computer_choice == "Scissors"
    statement << "Human wins this time."
  elsif player_choice == "paper" && computer_choice == "Rock"
    statement << "Human wins this time."
  elsif player_choice == "paper" && computer_choice == "Scissors"
    statement << "Computer wins this time."
  elsif player_choice == "scissors" && computer_choice == "Rock"
    statement << "Computer wins this time."
  else
    statement << "Human wins this time."
  end
  statement
end
