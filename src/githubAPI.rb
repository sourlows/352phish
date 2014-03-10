#githubAPI.rb
#author: djw223 (Dustin Walker)
#email: djw223@mail.usask.ca
#ruby version: 1.9.3p448
#library version: 1.9.1

require 'octokit'
require_relative "abstractAPI"
require 'pp'

class GithubAPI < AbstractAPI
  def initialize
    @supported = ["name", "email", "location", "company"]
  end

  def authenticate
    Octokit.connection_options[:ssl] = {:verify => false} #did this to make it easy for the marker to run it
    if $authDirectory.has_key?("Github")
	  Octokit.configure do |c|
        c.login = $authDirectory["Github"]["id"]
        c.password = $authDirectory["Github"]["secret"]
      end
	else
	  abort("no authentication information for Github found")
	end
    
	if $verbose
	  user = Octokit.user
	  pp user
	end
  end
  
  def canMakeQuery(queryTerms)
    queryTerms.count.times do |i|
	
	  if(!@supported.include?(queryTerms[i]))
	    puts "can't make query using Github" if $verbose
	    return false
	  end
	  
	end
	
	puts "can make query using Github" if $verbose
	return true
  end
end