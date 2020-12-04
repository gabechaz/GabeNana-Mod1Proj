require 'pry'

class Application

    attr_reader :prompt
    attr_accessor :player

    def initialize
        @prompt = TTY::Prompt.new
    end
################################################## LOG IN AND MENU METHODS ##################################################
    def welcome
        puts "Welcome to Pinscores!"
        puts "The #1 app for recording your pinball scores"
    end

    def ask_user_for_login_or_register
        
        prompt.select("Would you like to register or login?", cycle: true) do |menu|
            menu.choice "Log in", -> {login_helper}
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

    def quit
        puts "Goodbye #{player.name}!"
    end
##################################################### CREATE GAME METHODS ###############################################################

    def create_match
        Match.create(player_id: self.player.id, machine_id: machine_helper, score: capture_score)
        puts "Nice Score!!"
        sleep 1
        menu_or_delete
    end 

    def machine_helper
        prompt.select("Which pinball machine did you play?") do |menu|
            menu.choice "Metallica", -> {puts "Ah, Metallica. A modern classic."
            sleep 1
            machine_id_finder("Metallica")}
            menu.choice "Surfer", -> {puts "Surfer! An oldie but a goodie."
            sleep 1
            machine_id_finder("Surfer")}
        end
    end

    def capture_score
        puts "...and what was your score?"
        puts "INPUT SCORE___"
        score = gets.chomp
        validate_score(score)
    end

    def validate_score(input)
        input.delete(',')
    end

    ############################################ READ SCORE METHODS ##################################################################

    def see_scores
       prompt.select("How would you like to view your scores?", cycle: true) do |menu|
            menu.choice "See all my scores", -> {player_all_scores}
            menu.choice "See scores by machine", -> {score_by_machines}
            menu.choice "See scores by player", -> {machine_scores_with_player}
            menu.choice "See my high score by machine", -> {puts "need to work on high score by machine in the player class"}
            menu.choice "Back to main menu", -> {main_menu}
       end
    end

    def score_by_machines
        prompt.select("which machine would you like to look at?", cycle: true) do |menu|
            menu.choice "Batman", -> {machine_scores_finder("Batman")}
            menu.choice "Centaur", -> {machine_scores_finder("Centaur")}
            menu.choice "Congo", -> {machine_scores_finder("Congo")}
            menu.choice "Metallica", -> {machine_scores_finder("Metallica")}
            menu.choice "Surfer", -> {machine_scores_finder("Surfer")}
        end
    end
    
    def machine_scores_finder(machine_name)
       p Match.all.select {|match|match.machine.name == machine_name}.map{ |match|
           match.score
    }.sort
           
       
        sleep 2 
    end

    def machine_id_finder(machine_name)
        Machine.all.select {|machine|machine.name == machine_name}.first.id
    end
    
    def player_all_scores
        puts player.scores
        sleep 2
        see_scores
    end

    def played_with_which_machines
        puts player.machines_played_names.uniq
        sleep 2
        main_menu
    end

    def scores_by_machine(machine_name)
        puts players.scores_by_machine(machine_name)
        sleep 2
        see_scores
    end

    def machine_scores_with_player
        p Hash[Match.all.map {|match| [match.name, match.score]}]
        sleep 4
    end

    # def machine_scores
    #     matches.map {|match| match.score}
    # end

    # def machine_high_score
    #     scores.max_by {|score| score}
    # end

########################################## DELETE AND UPDATE METHODS #####################################################################

    def menu_or_delete
        puts "Are you sure that was the right score?"
        sleep 1
        puts "If it was the wrong score you can change it or delete it."
        sleep 1
        puts "Or you can return to the main menu."
        sleep 1
        prompt.select("Make your selection") do |menu| 
            menu.choice "Delete your score", -> {delete_score}
            menu.choice "Update your score", -> {update_score}
            menu.choice "Save your score and return to the main menu", -> {main_menu}
        end
    end

    def update_score
        puts "You goofy goofball, you put in the wrong score!"
        puts "Now what was the real score, little butterfingers."
        puts "INPUT SCORE___"
        input = gets.chomp
        Match.last.update(score: input)
        puts "Your score has been updated!"
        sleep 1
        main_menu
    end

    def delete_score
        puts "Your game of #{Match.last.machine.name} with a score of #{Match.last.score} has been deleted!"
        sleep 1
        Match.last.destroy
        main_menu
    end

    def self.wipe_scores
        Match.all.destroy_all
    end

end




   