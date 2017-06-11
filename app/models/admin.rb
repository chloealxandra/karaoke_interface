class Admin < User
  devise :database_authenticatable, :trackable, :timeoutable, :lockable 
end
