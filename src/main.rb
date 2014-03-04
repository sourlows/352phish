#main.rb
#author: djw223 (Dustin Walker)
#email: djw223@mail.usask.ca
#ruby version: 1.9.3p448
#library version: 1.9.1
require_relative "lib/trollop"
require 'pp'
require_relative "victim"
require_relative "victimList"

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

getUserOptions
if $test
  pp VictimList.instance.victims
end
