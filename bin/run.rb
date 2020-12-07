require_relative '../config/environment'
require 'pry'

application_instance = Application.new
application_instance.welcome_screen
player_or_nil = application_instance.ask_player_for_login_or_register

until player_or_nil
    system "clear"
    player_or_nil = application_instance.ask_player_for_login_or_register
end

application_instance.player = player_or_nil

application_instance.main_menu
