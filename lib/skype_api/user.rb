# coding: utf-8

module SkypeApi
  class User
    COMMAND = "USER"
    NOT_IN_CONTACT = 0        # never been in contact list.
    DELETE_FROM_CONTACT = 1   # deleted from contact list.
    AUTHORISATION_PENDING = 2 # pending authorisation.
    ADD_TO_CONTACT = 3        # added to contact list.
    METHOD_NAMES = [:fullname, :birthday, :sex, :language, :province, :city,
                    :phone_home, :phone_office, :phone_mobile,
                    :homepage, :about, :buddystatus]

    attr_reader :name, :fullname, :birthday, :sex, :language, :province, :city
    attr_reader :phone_home, :phone_office, :phone_mobile
    attr_reader :homepage, :about, :buddystatus

    def initialize(name = "")
      @name = name
      @fullname, @birthday, @sex, @language, @province, @city = nil
      @phone_home, @phone_office, @phone_mobile = nil
      @homepage, @about, @buddystatus = nil
    end

    def fifo
      self.methods.collect do |method|
        self.send method if /^get_.+$/.match(method.to_s)
      end.compact
    end

    def update(text)
      destination, user_name, property, *value = text.split
      property = "@#{property.downcase}".to_sym
      value = value.join(' ')
      if query_validate(destination, user_name, property)
        self.instance_variable_set property, /^\d+$/.match(value) ? value.to_i : value
      end
      self
    end

    METHOD_NAMES.each do |name|
      define_method "get_#{name.to_s}" do
        get_property(name)
      end
    end

    def get(*items)
      items.collect do |item|
        (self.respond_to? item) ? (self.send item) : nil
      end
    end

    def to_s
      text = "<name = #{name.inspect}"
      METHOD_NAMES.each do |name|
        text << ", #{name.to_s} = #{(self.send name).inspect}"
      end
      text << ">"
      text
    end

    def authorisation
      "SET #{COMMAND} #{@name} BUDDYSTATUS 2"
    end

  private
    def query_validate(destination, user_name, property)
      destination.upcase == COMMAND and user_name == @name and (self.instance_variable_defined? property)
    end

    def get_property(property)
      "GET #{COMMAND} #{@name} #{property.to_s.upcase}"
    end
  end
end
