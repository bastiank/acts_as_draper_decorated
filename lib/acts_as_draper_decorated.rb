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
      return @decorated if @decorated
      klass = self.class
      while klass
        begin
          @decorated ||= (klass.name + 'Decorator').constantize.decorate(self) 
          return @decorated
        rescue
          klass = klass.superclass
        end
      end
    end

    alias :d :decorated

  end
end

ActiveRecord::Base.send :include, ActsAsDraperDecorated 
