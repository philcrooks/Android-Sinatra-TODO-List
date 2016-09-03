require_relative( '../db/db_interface' )

class User
  TABLE = "users"
  UNASSIGNED = "unassigned"
  @@unassigned_id = nil

  attr_reader :id
  attr_accessor :name, :userid

  def save()
    @id = DbInterface.insert(TABLE, self)
    return @id
  end

  def update()
    return DbInterface.update(TABLE, self)
  end

  def delete()
    @id = User.destroy(@id) if @id
    return @id
  end

  def check_password( password )
    return ( @password == password )
  end

  def initialize( options )
    @id = options['id'].to_i
    @name = options['name']
    @userid = options['userid']
    @password = options['password']
  end

  # Class methods start here

  def self.all()
    users = DbInterface.select( TABLE )
    return users.map{ |u| User.new( u ) }
  end

  def self.by_id( id )
    users = DbInterface.select( TABLE, id )
    return nil if users.count == 0
    return User.new( users.first )
  end

  def self.by_name( userid )
    users = DbInterface.select( TABLE, name, "name" )
    return nil if users.count == 0
    return User.new( users.first )
  end

  def self.by_userid( userid )
    users = DbInterface.select( TABLE, userid, "userid" )
    return nil if users.count == 0
    return User.new( users.first )
  end

  def self.destroy( id = nil )
    return @@unassigned_id if (id && id == @@unassigned_id)
    @@unassigned_id = nil if !id
    DbInterface.delete( TABLE, id )
    return nil
  end

  def self.set_unassigned_id()
    if !@@unassigned_id
      user = User.by_name( UNASSIGNED )
      user = User.new( { 'name' => UNASSIGNED } ) if !user
      user.save
      @@unassigned_id = user.id
    end
  end

  def self.get_unassigned_id()
    @@unassigned_id = User.set_unassigned_id() if !@@unassigned_id
    return @@unassigned_id
  end
end