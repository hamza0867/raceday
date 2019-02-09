# Class representing a racer
class Racer
  # convenience method for access to client in console
  def self.mongo_client
    Mongoid::Clients.default
  end

  # convenience method for access to zips collection
  def self.collection
    mongo_client['racers']
  end

  def self.all(prototype = {}, sort = { number: 1 }, skip = 0, limit = nil)
    collection.find(prototype).sort(sort).skip(skip).limit(limit || 0)
  end
end
