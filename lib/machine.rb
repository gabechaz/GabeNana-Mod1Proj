class Machine < ActiveRecord::Base
    
    has_many :matches
    has_many :players, through: :matches

end