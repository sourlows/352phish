#githubAPI.rb
#author: djw223 (Dustin Walker)
#email: djw223@mail.usask.ca
#ruby version: 1.9.3p448
#library version: 1.9.1

require 'koala'
require_relative "abstractAPI"
require 'pp'

class FacebookAPI < AbstractAPI
  def initialize
    @supported = [:name, :music, :email]
	#@paginationLimit = 20
  end

  def authenticate
    if $authDirectory.has_key?("Facebook")
	  Koala.http_service.http_options = {
        :ssl => { :verify => false }
      }
      app_id = $authDirectory["Facebook"]["id"]
	  app_secret = $authDirectory["Facebook"]["secret"]
	  #@oauth = Koala::Facebook::OAuth.new(app_id, app_secret)
	  #@token = @oauth.get_app_access_token
	  #@graph = Koala::Facebook::API.new(@token)
	  #@graph = Koala::Facebook::API.new
	  puts("enter user access token: ")
	  token = gets
	  @graph = Koala::Facebook::API.new(token)
	  
	  #profile = @graph.get_object("dustin.walker.144")
	  #pp profile
	  
	  #likes = @graph.get_connections("dustin.walker.144", "likes")
	  #pp likes
    else
      abort("no authentication information for Facebook found")
    end
    
  end
  
  def canMakeQuery(queryTerms)
    queryTerms.count.times do |i|
    
      if(!@supported.include?(queryTerms[i]))
        puts "can't make query using Facebook" if $verbose
        return false
      end
      
    end
    
    puts "can make query using Facebook" if $verbose
    return true
  end
  
  def getQueryResults(queryTerms)
    #authenticate with provided credentials
    authenticate()
    
	#get the user's friends
	deepFriends = @graph.get_connections("me", "friends")
	
	#get each friend's "likes"
	deepFriends.each { |friend|
	  friend["likes"] = @graph.get_connections(friend["id"], "likes")
	}
	#pp deepFriends.first if $verbose
	
	nativeQuery = getNativeQuery(queryTerms)
	pp nativeQuery if $verbose

	#remove friends without all of the required query terms
    deepFriends.delete_if { |friend|
	  nativeQuery.any? {|term| friend["likes"].detect {|likedPage| likedPage["category"] == term} == nil}
	}
	
	pp deepFriends.count if $verbose
	
	#construct a victim from each friend and add them to the victimlist
	deepFriends.each{ |dFriend|
	  attrs = Hash.new
	  attrs[:name] = dFriend["name"]
	  nativeQuery.each { |term|
	    item = dFriend["likes"].detect {|likedPage| likedPage["category"] == term}
		globalTerm = getGlobalName(term)
	    attrs[globalTerm] = item["name"]
	  }
	  victim = Victim.new(attrs)
	  VictimList.instance.victims.push(victim)
	}
	
	pp VictimList.instance.victims if $verbose
  end
  
  def getNativeQuery(queryTerms)
    #don't worry about the name key, as all FB users have public names
    if queryTerms.include?(:name)
	  queryTerms.delete(:name)
	end
	
	if queryTerms.include?(:music)
	  queryTerms.delete(:music)
	  queryTerms.push("Musician/band")
	end
	
	return queryTerms
  end
  
  def getGlobalName(term)
    case term
	when "Musician/band"
	  return :music
	else
	  return :null
	end
  end
end