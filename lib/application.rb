require 'pry'

class Application

    attr_reader :prompt
    attr_accessor :player

    def initialize
        @prompt = TTY::Prompt.new
    end

    def welcome
        puts "Welcome to Pinscores!"
        puts "The #1 app for recording your pinball scores"
    end

    def ask_user_for_login_or_register
        
        prompt.select("Would you like to register or login?", cycle: true) do |menu|
            menu.choice "Login", -> {login_helper}
            menu.choice "Register", -> {register_helper}
        end
    end

    def login_helper
        Player.login_a_player
    end

    def register_helper
        Player.register_a_player
    end

    def main_menu
        player.reload
        system "clear"

        prompt.select("#{player.name}, this is the main menu, what would you like to do?", cycle: true) do |menu|
            menu.choice "Start a game", -> {start_a_game}
            menu.choice "See scores", -> {see_scores}
            menu.choice "See all the machines I played", -> {played_with_which_machines}
            menu.choice "Record a score", -> {create_match}
            menu.choice "Quit the game", -> {quit}
        end     
    end


    def see_scores
       prompt.select("Here are the scores menu.", cycle: true) do |menu|
            menu.choice "See all my scores", -> {player_all_scores}
            menu.choice "See scores by machine", -> {machine_id_finder}
            menu.choice "See my high score by machine", -> {puts "need to work on high score by machine in the player class"}
            menu.choice "Back to main menu", -> {main_menu}
       end
    end

    def score_by_machines
        prompt.select("which machine would you like to look at?", cycle: true) do |menu|
            menu.choice "Batman", -> {}
            menu.choice "Centaur", -> {}
            menu.choice "Congo", -> {}
            menu.choice "Metallica", -> {puts machine_finder("Metallica")}
            menu.choice "Surfer", -> {[]}
        end
    end
            
    
    def machine_helper
        prompt.select("Which pinball machine did you play?") do |menu|
            menu.choice "Metallica", -> {puts "Ah, Metallica. A modern classic."
            sleep 1
            machine_finder("Metallica")}
            menu.choice "Surfer", -> {puts "Surfer! An oldie but a goodie."
            sleep 1
            machine_finder("Surfer")}
        end
    end
    
    
    def machine_finder(machine_name)
        Machine.all.select {|machine|machine.name == machine_name}
    end
    
    def validate_score(input)
        input.delete(',')
    end
    
    def capture_score
        puts "...and what was your score?"
        puts "INPUT SCORE___"
        score = gets.chomp
        validate_score(score)
    end
    
    def create_match
        Match.create(player_id: self.player.id, machine_id: machine_helper, score: capture_score)
        puts "Nice Score!!"
        sleep 1
        main_menu
    end

    def player_all_scores
        puts player.scores
        sleep 3
        see_scores
    end

    def played_with_which_machines
        puts player.machines_played_names.uniq
        sleep 3
        main_menu
    end

    def scores_by_machine(machine_name)
        puts players.scores_by_machine(machine_name)
        sleep 5
        see_scores
    end

    # def machine_scores
    #     matches.map {|match| match.score}
    # end

    # def machine_high_score
    #     scores.max_by {|score| score}
    # end

    def machine_scores_with_player
        Hash[matches.map {|match| [match.name, match.score]}]
    end

    def quit
        puts "Goodbye #{player.name}!"
    end
    
end




            # def cheese_or_pizza
    #     prompt.select("Would you like cheese or pizza?") do |menu|
    #         menu.choice "Cheese", -> {p "Here's your cheese"}
    #         menu.choice "Pizza", -> {p "Here's your pizza"}
    #     end
    # end

   