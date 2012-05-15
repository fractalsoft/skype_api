# coding: utf-8
require 'skype_api/user'

module SkypeApi
  class Profile < User
    COMMAND = "PROFILE"

    def update(text)
      destination, property, *value = text.split
      property = "@#{property.downcase}".to_sym
      value = value.join(' ')
      if query_validate(destination, property)
        self.instance_variable_set property, /^\d+$/.match(value) ? value.to_i : value
      end
      self
    end

  private
    def get_property(property)
      "GET #{COMMAND} #{property.to_s.upcase}"
    end

    def query_validate(destination, property)
      destination.upcase == COMMAND and (self.instance_variable_defined? property)
    end
  end
end
