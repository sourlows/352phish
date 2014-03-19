#victim.rb
#author: djw223 (Dustin Walker)
#email: djw223@mail.usask.ca
#ruby version: 1.9.3p448
#library version: 1.9.1
require 'pp'

class Victim

  attr_accessor :attributes

  def initialize(attr=Hash[:email=>"username@mailserver.com"])
    #@email = attr["email"]
    @attributes = attr
  end
  
  def display
	#pp(@email)
	pp(@attributes)
  end
end