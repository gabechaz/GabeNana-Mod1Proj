class Player < ActiveRecord::Base
    has_many :matches
    has_many :machines, through: :matches

    def scores
        matches.map {|match| match.score}
    end
    
    def machines_played_names
        machines.map {|machine| machine.name}
    end

    def scores_by_machine(machine_name)
        matches.select {|match| match.machine}.select {|match| match}
    end

    def high_score_by_machine(mach_id)
        scores_by_machine(mach_id).max_by {|score| score}
    end

    def self.login_a_player
        puts "Let's get you logged in, player"
        puts "What is your name?"
        name = gets.chomp
        player = Player.find_by(name: name)

        if player.nil?
            puts "Sorry, nobody with that name exists!"
            sleep 2
            puts "Did you spell it right? Why not try again?"
            sleep 1
            puts "Otherwise you may have to register your name..."
            sleep 1
            nil
        else
            puts "Welcome back #{player.name}!"
            sleep 1
            player
        end
    end

    def self.register_a_player
        puts "What is your name?"
        name = gets.chomp

        player = Player.find_by(name: name)

        if player
            puts "Sorry, that username is already taken"
        else
            Player.create(name: name)
        end
    end
    
end