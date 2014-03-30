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
    @supported = [:name, :email, :location, :company]
	@paginationLimit = 20
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
  
  def getQueryResults(queryTerms)
    #authenticate with provided credentials
    authenticate()
    
    #set octokit options, auto paginate is a bad idea when you combine it with all_users (memory overflow)
    Octokit.auto_paginate = false
    Octokit.per_page = 100
    
    #get a shallow list of users
    userList = Octokit.all_users
	@paginationLimit.times do
	  userList.concat Octokit.last_response.rels[:next].get.data
	end
    detailedUsers = Array.new
    
    #get a deeper user object for each shallow user entry and store it in our detailedUsers arrays
    userList.each { |usr|
      detailedUsers.push(Octokit.user(usr.attrs[:login]))
    }
    
    #remove users without all of the required query terms
    detailedUsers.delete_if { |usr|
	  queryTerms.any? {|term| !usr.attrs.key?(term) || usr.attrs[term].nil? || usr.attrs[term].empty?}
	}
	
	#add users to the victims list
	detailedUsers.each { |usr|
	  victim = Victim.new(usr.attrs)
	  VictimList.instance.victims.push(victim)
	}
    
    #write each user in detailedUsers to a file for verification/testing/caching
    File.open("githubUsers.txt", 'w') { |file| 
      detailedUsers.each { |usr|
        #for our purposes we are really only interested in the attrs hash of the user object
        file.puts(usr.attrs)
      }   
    }
    
    
    
  end
end