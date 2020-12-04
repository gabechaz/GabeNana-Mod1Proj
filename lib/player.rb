class Player < ActiveRecord::Base
    has_many :matches
    has_many :machines, through: :matches

    def scores
       machine = matches.map {|match|match.machine.name}
       score = matches.map {|match|match.score}
       puts "Here are your scores!"
        if machine.empty? || score.empty?
            puts "You have not played any matches yet!"
        elsif score.length > 0 && machine.length > 0
            matches.all.count.times do |i|
            puts "#{i + 1}. #{machine[i]} || #{score[i]}"
            end
        end
        "Nice scores!"
    end
    
    def machines_played_names
        machines.map {|machine| machine.name}
    end

    def scores_by_machine(machine_name)
        matches.select {|match| match.machine}.select {|match| match}
    end

    def high_score_by_machine(machine_name)
        scores_by_machine(machine_name).max_by {|score| score}
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

    def my_machine_scores_finder(machine_name)
        matches.select {|match|match.machine.name == machine_name}.map{ |match|
            match.score
     }.sort.reverse.each_with_index{|score, index| puts "#{index + 1}. #{score}"}
     p "Nice scores!"
     end


    
end