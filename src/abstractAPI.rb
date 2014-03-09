#abstractAPI.rb
#author: djw223 (Dustin Walker)
#email: djw223@mail.usask.ca
#ruby version: 1.9.3p448
#library version: 1.9.1

require_relative "abstractInterface"

class AbstractAPI
  include AbstractInterface
  
  def authenticate
    AbstractAPI.api_not_implemented(self)
  end
  
  def getQueryResults
    AbstractAPI.api_not_implemented(self)
  end
  
  def canMakeQuery
    AbstractAPI.api_not_implemented(self)
  end
  
  def getNativeQuery
    AbstractAPI.api_not_implemented(self)
  end
  
  private :getNativeQuery
end