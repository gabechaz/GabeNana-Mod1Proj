#Create
# player = Player.new(name:, "gabe")
# player.save
# gabe = Player.create(name:, "gabe")

# Match.destroy_all
# Player.destroy_all
Machine.destroy_all

# nana = Player.create(name: "Nana")
# gabe = Player.create(name: "Gabe")
# sam = Player.create(name: "Sam")

metallica = Machine.create(name: "Metallica")
batman = Machine.create(name: "Batman")
congo = Machine.create(name: "Congo")
surfer = Machine.create(name: "Surfer")
centaur = Machine.create(name: "Centaur")


# match1 = Match.create(machine_id: metallica.id, player_id: nana.id, score: 100)
# match2 = Match.create(machine_id: metallica.id, player_id: gabe.id, score: 45)
# match3 = Match.create(machine_id: batman.id, player_id: gabe.id, score: 50)
# match4 = Match.create(machine_id: congo.id, player_id: sam.id, score: rand(100))
# match5 = Match.create(machine_id: congo.id, player_id: nana.id, score: rand(100))
# match6 = Match.create(machine_id: congo.id, player_id: nana.id, score: rand(100))
# match7 = Match.create(machine_id: metallica.id, player_id: nana.id, score: 200)

#Read
# Player.find(instance_id)
# Player.find_by(key: value)ie (name: "gabe")
# #will only return one instance. the first instance
# Player.where(key: value) 
# #returns an array of every instance in the DB for which the parameters run true


#update

# gabe.name = "gabriel"
# gabe.save
 
# gabe.update(name: "gabriel")


#Delete
# Player.destroy(instance id)
p "making matches!"