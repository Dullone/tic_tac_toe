class Board
	attr_reader :positions_marked, :rows, :columns
	EMPTY = "-"

	def initialize()
		@rows = 3
		@columns = 3
		@positions_marked = 0
		clear_board
	end

	def position_empty?(row, column)
		return @positions[row][column] == EMPTY
	end

	def clear_board
		@positions = []
		a_row = []
		@rows.times do |row|
			a_row = Array.new(@columns, EMPTY)
			@positions[row] = a_row
		end
	end

	def is_board_full?
		@positions_marked == (@rows * @columns)
	end

	def draw_board
		@columns.times do |row|
			print_row(row)
		end
	end
	
	def add_mark(row, column, player_mark)
		if position_empty? row, column
			@positions[row][column] = player_mark
			@positions_marked += 1
		else
			false
		end
	end

	def get_row(row)
		if row >= 0 && row < @rows
			@positions[row]
		else
			false
		end
	end

	def get_column(column)
		if column >= 0 && column < @columns
			column_array = []
			@columns.times do |i|
				column_array[i] = @positions[i][column]
			end
			column_array
		else
			false
		end
	end

	def get_diagonal(diagonal)
		diag_array = []
		if diagonal == 0
			@rows.times do |i|
				diag_array[i] = @positions[i][i]
			end
		elsif diagonal == 1
			@rows.times do |i|
				diag_array[i] = @positions[@rows - i - 1][@rows - i - 1]
			end
		end
		diag_array
	end

	private
	def print_row(row)
		@rows.times do |column|
			#only add seperator if not an end colum
			print "#{@positions[row][column]}"
			if column != @columns - 1
				print "|"
			end
		end
		print "\n"
	end
end

class Game
	@@player_one = :X
	@@player_two = :O

	def initialize
		@board = Board.new
		@player_turn = @@player_one
		@a_player_has_won = false
		@game_over = false
	end

	def start
		while !is_game_over?
			@board.draw_board
			take_turns
		end
		@board.draw_board
		if @board.is_board_full? then
			puts "Game over, board full."
		else
			swap_player_turn #currently on player who lost
			puts "Player #{@player_turn} has won!"
		end
	end

	def player_won
		#neither player can win without at least 5 turns passing
		if @board.positions_marked >= 5
			#check row
			@board.rows.times do |i|
				winner = array_has_victory @board.get_row i
				if winner
					@a_player_has_won = true
					return true
				end
			end
			#check colum
			@board.columns.times do |i|
				winner = array_has_victory @board.get_column i
				if winner
					@a_player_has_won = true
					return true
				end
			end
			#check diag
			2.times do |i|
				winner = array_has_victory @board.get_diagonal i
				if winner
					@a_player_has_won = true
					return true
				end
			end
		end
		false
	end

	#returns winning player or false if no win
	def array_has_victory(array)
		previous = array[0]
		(array.length - 1).times do |i|
			unless array[i] == array[i + 1] && array[i] != Board::EMPTY
				return false
			end
		end
		puts "check: player #{array[0]} won"
		array[0] #player who won
	end

	def is_game_over?
		@board.is_board_full? || player_won
	end

	def take_turns
		turn_finished = false
		while !turn_finished do
			print "#{@player_turn} enter row, column to take turn: "
			input = gets
			input.chomp!
			input = convert_input(input)
			if input then
				if @board.add_mark(input[0], input[1], @player_turn.to_s)
					turn_finished = true
					puts "position[#{input[0]}, #{input[1]}] marked #{@player_turn}"
				else
					puts "position occupied, pick another"
				end
			else
				puts "invalid input"
			end
		end
		swap_player_turn
	end

	def swap_player_turn
		if @player_turn == @@player_one 
			@player_turn = @@player_two
		else
			@player_turn = @@player_one
		end
	end

	def convert_input(input)
		input_array = input.split(",").map! { |i| i.to_i }
		if input_array.length == 2 && input_array.all? { |i| i.is_a? Integer } then 
			return input_array.map { |i| i = i - 1 }
		else
			return false
		end
	end
end

game = Game.new
game.start