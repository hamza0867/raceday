# Class representing a racer
class Racer
  include ActiveModel::Model

  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  def initialize(params = {})
    @id = params[:_id].nil? ? params[:id] : params[:_id].to_s
    @number = params[:number].to_i
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @group = params[:group]
    @secs = params[:secs].to_i
  end

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

  def self.find(id)
    val = id.is_a?(BSON::ObjectId) ? id : BSON::ObjectId(id)
    result = collection.find(_id: val).first
    result.nil? ? nil : Racer.new(result)
  end

  def save
    result = self.class.collection.insert_one(number: @number, \
                                              first_name: @first_name, \
                                              last_name: @last_name, \
                                              gender: @gender, \
                                              group: @group, \
                                              secs: @secs)
    @id = result.inserted_id.to_s
  end

  def update(params)
    @number = params[:number].to_i
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @group = params[:group]
    @secs = params[:secs].to_i
    params = { number: @number, first_name: @first_name, last_name: @last_name,\
               gender: @gender, group: @group, secs: @secs }
    self.class.collection.update_one({ _id: BSON::ObjectId(@id) },\
                                     '$set' => params)
  end

  def destroy
    self.class.collection.delete_one(number: @number)
  end

  def persisted?
    !@id.nil?
  end

  def created_at
    nil
  end

  def updated_at
    nil
  end
end
