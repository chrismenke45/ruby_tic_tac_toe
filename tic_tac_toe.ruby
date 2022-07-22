class GameBoard
  attr_reader :board, :winner, :moves_made
  attr_accessor :players

  def initialize
    @board = Array.new(3) { Array.new(3, "_") }
    @winner = false
    @moves_made = 0
    @players = []
  end

  def show_board
    @board.each { |item| puts "#{item[0]}|#{item[1]}|#{item[2]}" }
  end

  def mark_board(position_str, mark)
    if winner
      puts "The game has already been won by #{@winner}"
    else
      position = position_str_to_array(position_str)
      @board[position[0]][position[1]] = mark
      @moves_made += 1
      check_for_win()
    end
  end

  def valid_move?(position_str)
    position = position_str_to_array(position_str)
    #check if it is an array with values between 0 and 2, only an array with length of 2, and that it is an open postion on the board
    position.length == 2 && position[0].is_a?(Integer) && position[1].is_a?(Integer) && @board.dig(position[0], position[1]) == "_"
  end

  private

  def check_for_win
    #all conditionals check if the spaces just havent been taken

    #check the if any of the rows have 3 in a row
    @board.each { |row| @winner = row.uniq[0] if row.uniq[0] != "_" && row.uniq.length == 1 }
    #check if any columns have 3 in a row
    3.times { |index| @winner = @board[0][index] if @board[0][index] != "_" && @board[0][index] == @board[1][index] && @board[1][index] == @board[2][index] }
    #check if diagonals have 3 in a row (next 2 lines)
    @winner = @board[0][0] if @board[0][0] != "_" && @board[0][0] == @board[1][1] && @board[0][0] == @board[2][2]
    @winner = @board[0][2] if @board[0][2] != "_" && @board[0][2] == @board[1][1] && @board[2][0] == @board[0][2]
  end

  def position_str_to_array(str)
    #convert string to integer array
    arr = str.split(",")
    arr.map { |coordinate| coordinate.to_i }
  end
end

class Player
  attr_reader :name, :mark

  def initialize(name, mark)
    @name = name
    @mark = mark
  end
end

new_board = GameBoard.new
puts "Welcome to Tic Tac Toe!"
puts "Enter Player 1 Name:"
new_board.players.push(Player.new(gets.chomp, "X"))
puts "Enter Player 2 Name:"
new_board.players.push(Player.new(gets.chomp, "O"))
current_player = 1
while new_board.winner == false && new_board.moves_made < 9
  current_player == 0 ? current_player = 1 : current_player = 0
  #puts "#{current_player.name}, enter the coordinates of your move:"
  str = ""
  new_board.show_board
  puts "#{new_board.players[current_player].name}, enter the coordinates of your move:"
  loop do
    str = gets.chomp
    if new_board.valid_move?(str)
      new_board.mark_board(str, new_board.players[current_player].mark)
      break
    else
      new_board.show_board
      puts "INVALID INPUT: please input the row and column values between 0 and 2 separated only by a comma! (Example: 1,2)\n #{new_board.players[current_player].name}, please enter proper coordinates"
    end
  end
end
new_board.show_board
puts (new_board.winner ? "#{new_board.winner} wins!" : "Tie game!")
