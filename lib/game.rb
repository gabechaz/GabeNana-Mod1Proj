require 'pry'
require_relative './playfield.rb'


class Game < ActiveRecord::Base 
    # attr_accessor :speed, :ball, :bonus, :spinner, :score, :r_drop, :@l_drop

    # def initialize(score = 0)
       # super
        @@spinner = "unlit"
        @@r_drop = "up"
        @@l_drop = "up"
        @@speed = 0
        @@prompt = TTY::Prompt.new
        @@ball = 1
        @@bonus = 10
   # end

    def self.start_game
        game_instance = Game.new(score: 0)
        game_instance.welcome
    end
##################################################### WELCOME AND RULES METHODS #################################################
    

    def welcome
        surfer_playfield
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
        @@prompt.select("Would you like to start the game or read more rules?") do |menu|
            menu.choice "Read more rules", -> {more_rules}
            menu.choice "Plunge the ball!", -> {plunge}
        end
    end


    def more_rules
        system "clear"
        surfer_playfield
        @@prompt.select("What would you like to learn about?") do |menu|
        menu.choice "The score hole", -> {score_hole_rules}
        menu.choice "Balls and Bonus", -> {balls_and_bonus_rules}
        menu.choice "Lighting the spinner", -> {lighting_the_spinner_rules}
        menu.choice "Play the game!", -> {plunge}
        end
    end

    def balls_and_bonus_rules
        system "clear"
        surfer_playfield
        puts "Pinball games occur over three balls"
        puts "As the ball goes on, and you accomplish objectives, your bonus will increase."
        puts "As each ball drains, your bonus will be added to your score."
        puts "Unless you tilt!"
        puts "If you shove or nudge the machine too hard, you will tilt the game, emd your ball, and lose all your bonus!"
        puts "Beware the tilt!"
        @@prompt.select("Now let's get to flippin!") do |menu|
            menu.choice "Return", -> {more_rules}
        end
    end

    def lighting_the_spinner_rules
        system "clear"
        surfer_playfield
        puts "The spinner can be very valuble, expecially if your ball is moving quickly."
        puts "But it's even more valuble if you light it. One hundred times more valuble in fact!"
        puts "In order to light the spinner, you have to knock down both drop targets on the upper left side of the playfield"
        puts "These drop targets also give you bonus"
        @@prompt.select("Now let's get to flippin!") do |menu|
            menu.choice "Return", -> {more_rules}
        end
    end

    def score_hole_rules
        puts "Shooting the score hole will give you a random number of points between 1 and 20."
        puts "Then it will kick it to your left flipper!"
        @@prompt.select("Now let's get to flippin!") do |menu|
            menu.choice "Return", -> {more_rules}
        end
    end

#######################################PLAYFIELD METHODS #############################################################################

################################################TURN HELPER METHODS##################################################################

    def game_over
        self.save
        puts "Nice Game!"
        puts "Your total score is #{self.score}!"
        puts "Maybe you'll get a high score!"
        sleep 3
    end

    def add_score(arg)
        self.score += arg
        puts "Your score went up by #{arg}, and is now #{self.score}!"
    end    

    def say_bonus
        puts "Your bonus is at #{@@bonus}!"
    end

    def add_bonus
        puts "Your bonus went up ten!"
        @@bonus +=10
    end

    def speed_bonus
        @@speed / 10
    end

    def count_bonus
        self.score += @@bonus
        @@bonus = 10
    end

    def increase_speed
        puts "The ball is going faster!"
        @@speed += 5
    end

    def set_speed(arg)
        @@speed = arg
    end

    def say_speed
        puts "The ball's speed is #{@@speed}!"
        if @@speed > 80
            puts "Yipes!"
            sleep 0.5
    end
    end

    def check_tilt(arg)
        outc = rand (100)
        if outc + arg > 100
        tilt
        end
    end

    def tilt
        puts "!!!TILT!!!!"
        puts "No bonus for you!"
        sleep 1
        @@bonus = 0
        drain
    end

    def check_drain
        tilt_danger = 0
        puts " The ball is going towards the drain!"
        sleep 1
        @@prompt.select(" Do you want to try and nudge the ball to save it?") do |menu|
            menu.choice "Nudge the ball a little!", -> {tilt_danger = 30}
            menu.choice "Nudge the ball a lot!", -> {tilt_danger = 50 }
            menu.choice "Don't nudge the ball at all!", -> {tilt_danger = 0}
        end
        outc = rand (100) + @@speed - tilt_danger
        if outc > 80
            drain
            check_tilt(tilt_danger)
            sleep 1
        else
            puts "You saved the ball!"
            rand_flipper
            sleep 1
        end
    end

    def rand_flipper
        outc = rand (100)
        if outc > 50
            right_flipper_catch
        else
            left_flipper_catch
        end
    end 

    def drain
        puts "You drained ball #{@@ball}!!!!"
        sleep 1
    if @@ball == 3
        puts "That was your last ball! Better luck next time."
        game_over
        sleep 1
    elsif @@ball == 1
        puts "You still have 2 ball(s) left. Go get em!"
        sleep 1
        @@ball += 1
        plunge
    else 
        puts "This is your last ball!"
        puts "Make it count!"
        @@ball += 1
        plunge
    end
    sleep 1
    end

########################################## PLAYFIELD ELEMENT METHODS #####################################################################
    def plunge
        puts "Ball #{@@ball}!"
        say_bonus
        puts "The harder you plunge the ball, the more speed the ball will have when it gets to the playfield."
        puts "That means more points but also more danger!"
        @@prompt.select("How hard would you like to plunge the ball.") do |menu|
            menu.choice "Soft", -> {@@speed += 10}
            menu.choice "Medium", -> {@@speed += 25}
            menu.choice "Hard", -> {@@speed += 35}
        end
        plunger_anime
        outc = rand (100)
        if outc > 50
            left_inlane_gm
        else
            right_inlane_gm
        end
    end

    def inlanes
        outc = rand (100)
        if outc > 50
            right_inlane_gm
        else
            left_inlane_gm
        end
    end

    def right_inlane_gm
        plunger_to_r_inlane_anime
        puts "Your ball fell in the right inlane!"
        sleep 1
        self.add_bonus
        outc = rand (100)
        if outc > 50
            right_flipper_gm
        else
            pop_bumpers
        end
    end

    def left_inlane_gm
        plunger_to_l_inlane_anime
        puts "Your ball fell in the left inlane!"
        sleep 1
        self.add_bonus
        outc = rand (100)
        if outc > 50
            left_flipper_gm
        else
            pop_bumpers
        end
    end

    def pop_bumpers
        pop_bumper_bounce_anime
        puts "Your ball fell in the pop bumpers!"
        sleep 1
        pop_score = rand (10)
        pop_score += speed_bonus
        add_score(pop_score)
        increase_speed
        outc = rand (100)
        if outc > 75 
            right_inlane_gm
        elsif outc.between?(30, 74)
            pop_bumper_to_score_hole_anime
            sleep 1
            score_hole
        elsif outc.between?(20, 29)
            drop_target
            sleep 1
            drops
        else
            pop_bumper_to_drain_anime
            check_drain
        end
    end

    def run_spinner
        puts "You hit the spinner!"
        spinner_anime
        sleep 0.5
        if @@r_drop == "lit" && @@l_drop == "lit"
           add_score(10*@@speed/10)
        else
            add_score(1*@@speed/10)
        end
        puts "Nice rip!"
        sleep 1
        outc = rand (100)
        if outc > 50
            pop_bumpers
        else
            inlanes
        end
    end

    def catch_attempt
        outc = rand (100) + @@speed
        if outc > 100
            check_drain
        end
    end

    def right_flipper_gm
        puts "The ball is coming to your right flipper!"
        @@prompt.select("What are you go to do!?") do |menu|
            menu.choice "Flip the ball wildly!", -> {wild_flip}
            menu.choice "Try and catch the ball.", -> {catch_attempt
            right_flipper_catch}
            menu.choice "Let the ball bounce to the other flipper", -> {left_flipper_catch}
        end
    end

    def left_flipper_gm
        puts "The ball is coming to your left flipper!"
        @@prompt.select("What are you go to do!?") do |menu|
            menu.choice "Flip the ball wildly!", -> {wild_flip}
            menu.choice "Try and catch the ball.", -> {catch_attempt
            left_flipper_catch}
            menu.choice "Let the ball bounce to the other flipper", -> {right_flipper_catch}
        end
    end

    def right_flipper_catch
        right_flipper
        puts "You caught the ball! Nice!"
        sleep 1
        set_speed(20)
        @@prompt.select("What do you want to shoot for?") do |menu|
            menu.choice "The score hole", -> {
            right_flipper_to_score_hole_anime
            sleep 0.4
            score_hole}
            menu.choice "The spinner", -> {right_flipper_to_spinner
            sleep 0.5    
            run_spinner
            }
            menu.choice "The drop targets", -> {right_flipper_to_drop_target_anime
            sleep 1
            drops}
        end
    end

    def left_flipper_catch
        left_flipper
        puts "You caught the ball! Nice!"
        sleep 1
        set_speed(20)
        @@prompt.select("What do you want to shoot for?") do |menu|
            menu.choice "The score hole", -> {left_flipper_to_score_hole_anime
            sleep 0.4    
            score_hole
            }
            menu.choice "The spinner", -> {left_flipper_to_spinner
            sleep 0.5
            run_spinner
           }
            menu.choice "The drop targets", -> {left_flipper_to_drop_target_anime
        sleep 0.5
        drops
        }
        end
    end

    def wild_flip
        puts "You flipped the ball like a lunatic!"
        sleep 1
        outc = rand (100) - @@speed
        @@speed += 25
            if outc > 70
                run_spinner
            elsif outc.between?(69, 40)
                score_hole
            elsif outc.between?(20, 40)
                drops
            else
                drain
        
        end
    end

    def score_hole
        puts "You fell in the score hole!"
        sleep 1
        puts "Get ready for a random amount of points!"
        sleep 1
        hole = rand (20)
        self.score += hole
        puts "You got #{hole} points!"
        sleep 1
        set_speed(30)
        sleep 0.2
        score_hole_back_to_left_flipper_anime
        sleep 0.2
        left_flipper_gm
    end

    def drops
        outc = rand (100)
        if outc > 50 
            left_drop
        else
            right_drop
        end
    end

    def left_drop
        puts "You hit the left drop target!"
        sleep 1
        add_bonus
        sleep 1
        @@l_drop = "lit"
        set_speed(@@speed + 15)
        outc = rand (100) - @@speed
        if outc > 70
            pop_bumpers
        elsif outc.between?(30, 69)
            inlanes
        else
            pop_bumper_to_drain_anime
            sleep 0.5
            drain
        end
    end

    def right_drop
        puts "You hit the right drop target!"
        sleep 1
        add_bonus
        sleep 1
        @@r_drop = "lit"
        set_speed(@@speed = 15)
        outc = rand (100) - @@speed
        if outc > 70
            pop_bumpers
        elsif outc.between?(30, 69)
            inlanes
        else
            pop_bumper_to_drain_anime
            sleep 0.5
            drain
        end
    end
end

