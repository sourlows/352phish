#emailHandler.rb
#author: djw223 (Dustin Walker)
#email: djw223@mail.usask.ca
#ruby version: 1.9.3p448
#library version: 1.9.1
require 'singleton'

class EmailHandler
  include Singleton
  
  def getUserQuery
    parseInputEmail
  end
  
  def compose
  end
  
  #extracts a query from an input email template
  #returns an array of query terms
  def parseInputEmail
	puts "extracting query terms from #{$file}" if $verbose
	
	terms = Array.new
	
	s = IO.read($file)
	
	pp(s) if $test
	
  end
  
  def writeEmailToDisk
  end
  
  private :parseInputEmail, :writeEmailToDisk
end