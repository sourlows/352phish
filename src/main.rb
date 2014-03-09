#main.rb
#author: djw223 (Dustin Walker)
#email: djw223@mail.usask.ca
#ruby version: 1.9.3p448
#library version: 1.9.1
require 'trollop'
require 'pp'
require_relative "victim"
require_relative "victimList"
require_relative "emailHandler"

#the list of APIs to send queries to
targetAPIs = Array.new

#true if verbose mode (print out what is happening with requests) is enabled
$verbose = false

#true if test mode (various test/stub functions) is enabled
$test = false

#the name of the file corresponding to the input email template
$file = nil

def parseInput
end

def acquireTargetAPIs
end

def getVictims
end

# determines which option flags have been set by command line invocation and sets corresponding global variables appropriately
# the --test flag should not be used by anyone who doesn't know what they are doing or you'll get unanticipated behaviour
def getUserOptions
  opts = Trollop::options do
    opt :verbose, "print out all kinds of information about http requests"
    opt :file, "specify an input email template file", :type => :string
    opt :test, "enable test functionality"
  end
  
  $verbose = opts[:verbose]
  $file = opts[:file]
  $test = opts[:test]
  
  #kill the program if the user specifies a non existent template file
  Trollop::die :file, "must exist" unless File.exist?($file) if $file
  
  if $test
    pp(opts)
  end
end

def generateEmails
end


#MAIN ENTRY POINT
getUserOptions
pp VictimList.instance.victims if $test
EmailHandler.instance.getUserQuery if $file

private :parseInput, :acquireTargetAPIs, :getVictims, :getUserOptions, :generateEmails
