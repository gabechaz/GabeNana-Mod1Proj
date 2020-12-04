


class Game
    attr_reader :ball_speed, :ball, :bonus, :spinner
    @@all = []

    def initialize
        welcome
    end

    def welcome
        puts "Welcome to Surfer pinball!"
        sleep 0.5
        puts "You put the ball on the playfield by pulling and releasing the plunger."
        sleep 0.5
        puts "Keep the ball alive by hitting it with your flippers."
        sleep 0.5
        puts "The faster the ball is going, the more points you'll get."
        sleep 0.5
        puts "Especially if you can hit the spinner!"
        sleep 0.5
        prompt.select("Would you like to start the game or read more rules?") do |menu|
            menu.choice("Read more rules", -> {more_rules})
            menu.choice("Plunge the ball!", -> {plunge})
        end
    end

    def more_rules

    end


def plunge

end

end