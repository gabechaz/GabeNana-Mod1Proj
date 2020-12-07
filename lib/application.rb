require 'pry'

class Application

    attr_reader :prompt
    attr_accessor :player

    def initialize
        @prompt = TTY::Prompt.new
    end
################################################## LOG IN AND MENU METHODS ##################################################
    def welcome_screen
        puts "Welcome to Pinscores!"
        puts "The #1 app for recording your pinball scores"
    end

    def ask_player_for_login_or_register
        prompt.select("Would you like to Login or Register?", symbols: { marker: "❍" }, cycle: true) do |menu|
            sleep 0.2
            menu.choice "Log in", -> {login_helper}
            sleep 0.2
            menu.choice "Register", -> {register_helper}
        end
    end

    def return_to_main_menu
        prompt.select("Return to Main Menu?", symbols: { marker: "❍" }, cycle: true) do |menu|
            sleep 0.2
        menu.choice "Main Menu", -> {main_menu}
        end
    end

    def login_helper
        Player.login_a_player
    end

    def register_helper
        Player.register_a_player
    end

    def record_score
        binding.pry
        Match.create(player_id: self.player.id, machine_id_finder("Surfer"), score: Game.last.score)
    end

    def main_menu
        player.reload
        system "clear"
        prompt.select("#{player.name}, this is the main menu, what would you like to do?", symbols: { marker: "❍" }, cycle: true) do |menu|
            sleep 0.2
            menu.choice "Start a game", -> {Game.start_game
        record_score
        main_menu}
            menu.choice "Record a score", -> {create_match}
            sleep 0.2
            menu.choice "See scores", -> {see_scores}
            sleep 0.2
            menu.choice "See all machines played", -> {played_with_which_machines}
            sleep 0.2
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
        prompt.select("Which pinball machine did you play?", symbols: { marker: "❍" }, cycle: true) do |menu|
            menu.choice "Metallica", -> {puts "Ah, Metallica. A modern classic."
            sleep 0.2
            machine_id_finder("Metallica")}
            menu.choice "Surfer", -> {puts "Surfer! An oldie but a goodie."
            sleep 0.2
            machine_id_finder("Surfer")}
            menu.choice "Centaur", -> {puts "She's nasty! She's tough! She's a centaur!"
            sleep 0.2
            machine_id_finder("Centaur")}
            sleep 0.2
            menu.choice "Batman", -> {puts "Dunanunanunnnaaaah"
            machine_id_finder ("Batman")}
            sleep 0.2
            menu.choice "Congo", -> {puts "I love Michael Crichton!"
            machine_id_finder ("Congo")}

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
        system "clear"
        prompt.select("How would you like to view your scores?", symbols: { marker: "❍" }, cycle: true) do |menu|
            sleep 0.2
            menu.choice "See my scores", -> {player_score_menu}
            sleep 0.2
            menu.choice "See a machines high scores", -> {machine_high_score_menu}
            sleep 0.2
            menu.choice "Back to main menu", -> {main_menu}
       end
    end

    def player_score_menu
        system "clear"
        prompt.select("Your scores menu", symbols: { marker: "❍" }, cycle: true) do |menu|
            sleep 0.2
            menu.choice "See all my scores", -> {player_all_scores}
            sleep 0.2
            menu.choice "See my scores by machine", -> {score_by_machines_menu}
            sleep 0.2
            menu.choice "Back to scores menu", -> {see_scores}
        end
    end
        

    def machine_high_score_menu
        system "clear"
        prompt.select("Which machine's high scores would you like to look at?", symbols: { marker: "❍" }, cycle: true) do |menu|
            sleep 0.2
            menu.choice "Batman", -> {machine_high_score("Batman")}
            sleep 0.2
            menu.choice "Centaur", -> {machine_high_score("Centaur")}
            sleep 0.2
            menu.choice "Congo", -> {machine_high_score("Congo")}
            sleep 0.2
            menu.choice "Metallica", -> {machine_high_score("Metallica")}
            sleep 0.2
            menu.choice "Surfer", -> {machine_high_score("Surfer")}
        end
    end

    def machine_high_score(mach)
        system "clear"
        puts "These are the top three scores"
        matches.select {|match| match.machine.name == mach}.sort_by {|match| match.score}.reverse
            .take(3).each_with_index do |match, index| 
         puts "#{index + 1}. #{match.player.name} || #{match.score} "
        end
        return_to_main_menu
     end

    def score_by_machines_menu
        system "clear"
        prompt.select("which machine would you like to look at?", symbols: { marker: "❍" }, cycle: true) do |menu|
                menu.choice "Batman", -> {player.my_machine_scores_finder("Batman")}
                menu.choice "Centaur", -> {player.my_machine_scores_finder("Centaur")}
                menu.choice "Congo", -> {player.my_machine_scores_finder("Congo")}
                menu.choice "Metallica", -> {player.my_machine_scores_finder("Metallica")}
                menu.choice "Surfer", -> {player.my_machine_scores_finder("Surfer")}
                menu.choice "Main Menu", -> {main_menu}
        end
        return_to_main_menu
    end 

    def machine_id_finder(machine_name)
        Machine.all.select {|machine|machine.name == machine_name}.first.id
    end
    
    def player_all_scores
        p player.scores
        sleep 3
        prompt.select("Back to Scores Menu?") do |menu|
            sleep 0.2
            menu.choice "Return to Scores Menu", -> {see_scores}
        end
    end

    def played_with_which_machines
        puts player.machines_played_names.uniq
        sleep 2
        prompt.select("Back to Main Menu?") do |menu|
            sleep 0.2
            menu.choice "Return to Main Menu", -> {main_menu}
        end
    end

    def scores_by_machine(machine_name)
        puts players.scores_by_machine(machine_name)
        sleep 2
        see_scores
    end

 




########################################## DELETE AND UPDATE METHODS #####################################################################

    def menu_or_delete
        puts "Are you sure that was the right score?"
        sleep 1
        puts "If it was the wrong score you can change it or delete it."
        sleep 1
        puts "Or you can return to the main menu."
        sleep 1
        prompt.select("Make your selection", symbols: { marker: "❍" }, cycle: true) do |menu| 
            sleep 0.2
            menu.choice "Delete your score", -> {delete_score}
            sleep 0.2
            menu.choice "Update your score", -> {update_score}
            sleep 0.2
            menu.choice "Save your score and return to the main menu", -> {main_menu}
        end
    end

    def update_score
        system "clear"
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


    ############################################ HELPER METHODS #################################################################
    def matches
        Match.all
    end

end




   