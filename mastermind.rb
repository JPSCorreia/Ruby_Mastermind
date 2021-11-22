
require 'rainbow/refinement'
using Rainbow

class Mastermind
  
  def initialize

    # Set winner as none and turn count as 1.
    @game_winner = 0
    @turn_count = 1
    @valid_input = false;

    # Set balls of 6 different colors.
    @G_ball = 'O'.green
    @Y_ball = 'O'.yellow
    @B_ball = 'O'.blue
    @C_ball = 'O'.cyan
    @M_ball = 'O'.magenta
    @R_ball = 'O'.red
    @O_ball = 'O'.color(:orange)
    @W_ball = 'O'.white

    # CPU randomly chooses code (no colors repeated) .
    @CPU_code = []
    @random_choice_array = (1..6).to_a.shuffle
    4.times { |index|       
      @random_choice = @random_choice_array.pop
      
      case @random_choice
      when 1
        @CPU_code.push(@G_ball)
      when 2
        @CPU_code.push(@Y_ball)
      when 3
        @CPU_code.push(@B_ball)
      when 4
        @CPU_code.push(@C_ball)
      when 5
        @CPU_code.push(@M_ball)
      when 6
        @CPU_code.push(@R_ball)
      end
    }
  end

  # Function to show array of colored balls as a string
  private
  def stringify_balls(code)
    return code.reduce do |sum, element| 
      sum + ' ' + element
    end
  end

  # Play a single turn in the game.
  private
  def play_turns
    @player_input = ''
    while ( (@game_winner == 0) && (@turn_count < 13) ) do

      while (@valid_input == false) do

        @valid_input = true

        until (@player_input.length == 4) do
          # Ask player for choice
          puts 'Please insert code:'.blue
          @player_input = gets.chomp
          if (@player_input.length != 4) 
            puts 'error: invalid input'.red
          end
        end

        @player_code = @player_input.upcase.split('')
        if (@player_code.uniq.length != @player_code.length)
          @valid_input = false
        end
        @player_input = ''

        @player_code.map! { |element|
          case element
          when 'G'
            @G_ball
          when 'Y'
            @Y_ball
          when 'B'
            @B_ball
          when 'C'
            @C_ball
          when 'M'
            @M_ball
          when 'R'
            @R_ball
          else
            @valid_input = false
          end
        }
        if (@valid_input == false)
          puts 'error: invalid input'.red
        end
      end

      puts "Player (try ##{@turn_count}): #{stringify_balls(@player_code)}".yellow
      verify_code(@player_code)
      @turn_count += 1
      @valid_input = false

    end
  end

  # Verify if code and answer accordingly.
  private
  def verify_code(code)

    @CPU_colors_to_check = []
    @player_colors_to_check = []
    @orange_ball_num = 0
    @orange_and_white_balls = []
    @white_ball_num = 0

    if (code[0] == @CPU_code[0])
      @orange_and_white_balls.push(@O_ball)
      @orange_ball_num += 1
    else
      @player_colors_to_check.push(code[0])
      @CPU_colors_to_check.push(@CPU_code[0])
    end

    if (code[1] == @CPU_code[1])
      @orange_and_white_balls.push(@O_ball)
      @orange_ball_num += 1
    else
      @player_colors_to_check.push(code[1])
      @CPU_colors_to_check.push(@CPU_code[1])
    end

    if (code[2] == @CPU_code[2])
      @orange_and_white_balls.push(@O_ball)
      @orange_ball_num += 1
    else
      @player_colors_to_check.push(code[2])
      @CPU_colors_to_check.push(@CPU_code[2])
    end

    if (code[3] == @CPU_code[3])
      @orange_and_white_balls.push(@O_ball)
      @orange_ball_num += 1
    else
      @player_colors_to_check.push(code[3])
      @CPU_colors_to_check.push(@CPU_code[3])
    end

    @player_colors_to_check.each { |player_element|
      @CPU_colors_to_check.each { |cpu_element|
        if (player_element == cpu_element)
          @white_ball_num += 1
          @orange_and_white_balls.push(@W_ball)
        end
      }
    }

    puts "CPU: #{stringify_balls(@orange_and_white_balls)}".cyan

    # Set player as winner when he gets all 4 balls right
    if (@orange_ball_num == 4)
      @game_winner = 1
    end

  end

  # Instructions to the game
  private
  def instructions
    puts ''
    puts ''
    puts 'Game Rules:'.cyan
    puts ''
    puts 'Orange ball '.color(:orange) + 'means 1 ball of correct color in correct place, '.cyan + 'White ball '.white + 'means 1 ball of correct color but not in a correct place.'.cyan
    puts ''
    puts 'You must enter your code in a string of letters, each letter representing a color(no repeating colors):  '.cyan + 'G = Green   '.green + 'Y = Yellow   '.yellow + 'B = Blue   '.blue + 'C = Cyan   '.cyan + 'M = Magenta   '.magenta + 'R = Red'.red
    puts "ie: 'RGBY' = ".cyan + 'O '.red + 'O '.green + 'O '.blue + 'O '.yellow
    puts ''
    # puts 'CPU randomly chosen code: '.cyan + stringify_balls(@CPU_code)
    # puts ''
    puts 'Starting a game of Mastermind...'.magenta
    puts ''
  end

  # Start a new game.
  public
  def play

    instructions
    play_turns
    (@game_winner == 1)? (p 'You have won!') : (p 'You lost.')

  end 
end


# Begin a new game of Mastermind
test_game = Mastermind.new()
test_game.play
