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
    @supported = [:name, :music, :email, :politician, :book, :author, :software]
	#@paginationLimit = 20
  end

  def authenticate
    if $authDirectory.has_key?("Facebook")
	  Koala.http_service.http_options = {
        :ssl => { :verify => false }
      }
      app_id = $authDirectory["Facebook"]["id"]
	  app_secret = $authDirectory["Facebook"]["secret"]
	  puts("enter user access token: ")
	  token = gets
	  @graph = Koala::Facebook::API.new(token)
	  
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
	
	if($limit && $limit < deepFriends.count)
	  deepFriends = deepFriends[0,$limit]
	end
	
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
	
	if queryTerms.include?(:politician)
	  queryTerms.delete(:politician)
	  queryTerms.push("Politician")
	end
	
	if queryTerms.include?(:book)
	  queryTerms.delete(:book)
	  queryTerms.push("Book")
	end
	
	if queryTerms.include?(:author)
	  queryTerms.delete(:author)
	  queryTerms.push("Author")
	end
	
	if queryTerms.include?(:software)
	  queryTerms.delete(:software)
	  queryTerms.push("Software")
	end
	
	return queryTerms
  end
  
  def getGlobalName(term)
    case term
	when "Musician/band"
	  return :music
	when "Politician"
	  return :politician
	when "Author"
	  return :author
	when "Book"
	  return :book
	when "Software"
	  return :software
	else
	  return :null
	end
  end
end