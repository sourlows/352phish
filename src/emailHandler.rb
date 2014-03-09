#emailHandler.rb
#author: djw223 (Dustin Walker)
#email: djw223@mail.usask.ca
#ruby version: 1.9.3p448
#library version: 1.9.1
require 'singleton'

class EmailHandler
  include Singleton
  
  def getUserQuery
    querySet = parseInputEmail()
	return querySet
  end
  
  def compose
  end
  
  #extracts a query from an input email template
  #returns an array of query terms
  def parseInputEmail
	puts "extracting query terms from #{$file}" if $verbose
	
	s = IO.read($file)
	terms = s.scan(/(?<=\[)(.*?)(?=\])/)
	
	abort("template did not contain any query terms") if terms.count <1
	
	pp(terms) if $verbose
	return terms
  end
  
  def writeEmailToDisk
  end
  
  private :parseInputEmail, :writeEmailToDisk
end