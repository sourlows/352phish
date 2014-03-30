#emailHandler.rb
#author: djw223 (Dustin Walker)
#email: djw223@mail.usask.ca
#ruby version: 1.9.3p448
#library version: 1.9.1
require 'singleton'
require 'securerandom'

class EmailHandler
  include Singleton
  
  def getUserQuery
    querySet = parseInputEmail()
	return querySet
  end
  
  #writes an email to each victim
  #can only be called after a victim list has been constructed
  def compose
    terms = getUserQuery()
    VictimList.instance.victims.each { |vic|
	  composed = String.new(@emailString)
	  terms.each { |term|
	    termString = term.to_s
	    composed.gsub!(/\[#{termString}\]/, vic.attributes[term])
	  }
	  writeEmailToDisk(composed)
	}
    
  end
  
  #extracts a query from an input email template
  #returns an array of query terms
  def parseInputEmail
	puts "extracting query terms from #{$file}" if $verbose
	
	@emailString = IO.read($file)
	
	stringTerms = @emailString.scan(/(?<=\[)(.*?)(?=\])/)
	stringTerms.flatten!
	
	terms = stringTerms.map { |s| s.to_sym }
	
	#abort if we can't find at least one query term
	abort("template did not contain any query terms") if terms.count <1
	
	pp(terms) if $verbose
	return terms
  end
  
  def writeEmailToDisk(emailString)
    filename = "out/" + SecureRandom.hex + ".txt"
	File.open(filename, 'w') { |file| file.write(emailString) }
  end
  
  private :parseInputEmail, :writeEmailToDisk
end