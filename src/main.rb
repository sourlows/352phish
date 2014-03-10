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
require_relative "githubAPI"

#the list of APIs to send queries to
targetAPIs = Array.new

#true if verbose mode (print out what is happening with requests) is enabled
$verbose = false

#true if test mode (various test/stub functions) is enabled
$test = false

#the name of the file corresponding to the input email template
$file = nil

#the name of the file corresponding to the authorization information
$auth = nil

$authDirectory = Hash.new

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
	opt :auth, "specify an file containing authentication info", :type => :string
    opt :test, "enable test functionality"
  end
  
  $verbose = opts[:verbose]
  $file = opts[:file]
  $auth = opts[:auth]
  $test = opts[:test]
  
  #kill the program if the user specifies a non existent template file
  Trollop::die :file, "must exist" unless File.exist?($file) if $file
  
  #kill the program if the user specifies a non existent authorization file
  Trollop::die :auth, "must exist" unless File.exist?($auth) if $auth
  
  if $test
    pp(opts)
  end
end

def generateEmails
end

def parseAuth
  puts "extracting authentication information from #{$auth}" if $verbose
  
  s = IO.read($auth)
  
  apiNames = s.scan(/^([A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$)/)
  ids = s.scan(/^id: ([A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$)/)
  secrets = s.scan(/^secret: (.*$)/)
  
  apiNames.flatten!
  ids.flatten!
  secrets.flatten!
  
  if((apiNames.count != ids.count) || (apiNames.count != secrets.count) || (secrets.count != ids.count))
    abort("invalid config file format, each entry must have a corresponding id and secret(password), see documentation")
  end
  
  apiNames.count.times do |i|
    $authDirectory[apiNames[i]] = { "id" => ids[i], "secret" => secrets[i] }
  end
  
  pp $authDirectory if $verbose
  
end

#MAIN ENTRY POINT
getUserOptions
pp VictimList.instance.victims if $test
querySet = EmailHandler.instance.getUserQuery if $file
parseAuth if $auth
targetAPIs.push(GithubAPI.new)
targetAPIs.first.canMakeQuery(querySet)

private :parseInput, :acquireTargetAPIs, :getVictims, :getUserOptions, :generateEmails
