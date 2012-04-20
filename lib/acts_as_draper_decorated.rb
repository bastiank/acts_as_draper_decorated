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
    def decorated type = nil
      type = type.to_s unless type.nil?
      if type.nil?
        return @decorated if @decorated
      else
        @decorated_types ||= {}
        return @decorated_types[type] if @decorated_types[type] 
      end
      klass = self.class
      while klass
        begin
          if type.nil?
            @decorated ||= (klass.name + 'Decorator').constantize.decorate(self) 
            return @decorated
          else
            return @decorated_types[type] ||= ("#{type.to_s.classify}#{klass.name}Decorator").constantize.decorate(self)
          end
        rescue
          klass = klass.superclass
        end
      end
    end

    alias :d :decorated

  end
end

ActiveRecord::Base.send :include, ActsAsDraperDecorated 
