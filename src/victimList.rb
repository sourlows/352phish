#victimList.rb
#author: djw223 (Dustin Walker)
#email: djw223@mail.usask.ca
#ruby version: 1.9.3p448
#library version: 1.9.1
require 'singleton'

class VictimList
  include Singleton
  
  attr_accessor :victims
  
  def initialize
	@victims = Array.new
	
	if $test
	  @victims.push(Victim.new)
	end
  end
end