# coding: utf-8

module SkypeApi
  class ChatMessage
    COMMAND = "CHATMESSAGE"
    METHOD_NAMES = [:chatname, :body, :status]

    attr_reader :id, :status, :body, :chatname

    def initialize(id = nil)
      @id = id
      @status, @body, @chatname = nil
    end

    def fifo
      self.methods.collect do |method|
        self.send method if /^get_.+$/.match(method.to_s)
      end.compact
    end

    def reply
      "#{COMMAND} #{@chatname} #{SkypeApi::MsgRequest.reply(@body)}" if @chatname and @body and @status == "RECEIVED"
    end

    def update(text)
      destination, msg_id, property, *value = text.split
      msg_id = msg_id.to_i
      property = "@#{property.downcase}".to_sym
      value = value.join(' ')
      if query_validate(destination, msg_id, property)
        self.instance_variable_set property, /^\d+$/.match(value) ? value.to_i : value
      end
      self
    end

    METHOD_NAMES.each do |name|
      define_method "get_#{name.to_s}" do
        get_property(name)
      end
    end

    def to_s
      text = "<id = #{id.inspect}"
      METHOD_NAMES.each do |name|
        text << ", #{name.to_s} = #{(self.send name).inspect}"
      end
      text << ">"
      text
    end

  private
    def get_property(property)
      "GET #{COMMAND} #{@id} #{property.to_s.upcase}"
    end

    def query_validate(destination, msg_id, property)
      destination.upcase == COMMAND and msg_id == @id and (self.instance_variable_defined? property)
    end
  end
end
