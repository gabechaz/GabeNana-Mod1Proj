class Match < ActiveRecord::Base
    
    belongs_to :machine
    belongs_to :player

    def name
        player.name
    end

end