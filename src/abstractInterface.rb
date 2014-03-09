#abstractInterface.rb
#author: djw223 (Dustin Walker) adapted from code by Mark Bates
#email: djw223@mail.usask.ca
#ruby version: 1.9.3p448
#library version: 1.9.1

module AbstractInterface

  class InterfaceNotImplementedError < NoMethodError
  end

  def self.included(className)
    className.send(:include, AbstractInterface::Methods)
    className.send(:extend, AbstractInterface::Methods)
  end

  module Methods

    def api_not_implemented(className)
      caller.first.match(/in \`(.+)\'/)
      method_name = $1
      raise AbstractInterface::InterfaceNotImplementedError.new("#{className.class.name} needs to implement '#{method_name}' for interface #{self.name}!")
    end
  end
  
end