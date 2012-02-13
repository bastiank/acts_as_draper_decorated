require 'active_record'

module ActsAsDraperDecorated
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_draper_decorated
      include ActsAsDraperDecorated::InstanceMethods
    end
  end

  module InstanceMethods
    def decorated
      @decorated ||= (self.class.name + 'Decorator').constantize.decorate(self) 
    end

    alias :d :decorated

  end
end

ActiveRecord::Base.send :include, ActsAsDraperDecorated 
