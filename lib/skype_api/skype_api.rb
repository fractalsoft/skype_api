# coding: utf-8
require 'dbus'
require 'thread'

module SkypeApi
  SERVICE = "org.fractalsoft.skype"
  SKYPE_SERVICE = "com.Skype.API"
  SKYPE_TO_CLIENT_PATH = "/com/Skype/Client"
  CLIENT_TO_SKYPE_PATH = "/com/Skype"
  CLIENT_INTERFACE = "com.Skype.API.Client"

  class Notify < DBus::Object
    dbus_interface CLIENT_INTERFACE do
      dbus_method :Notify, "in data:s" do |message|
        # TODO testing
        Client.instance.proxy(message)
      end
    end
  end

  class Api
    def self.instance
      @instance ||= new
    end

    def attach(protocol_number = 7, name = "SkypeApi")
      unless @is_on
        api.Invoke "NAME #{name}"
        api.Invoke "PROTOCOL #{protocol_number}"

        thread = Thread.new do
          receiving_service = bus.request_service(SERVICE)
          receiving_service.export(Notify.new(SKYPE_TO_CLIENT_PATH))
          dbus_event_loop = DBus::Main.new
          dbus_event_loop << bus
          dbus_event_loop.run
        end
        thread.run

        @is_on = true
      end
    end

    def invoke(query)
      api.Invoke(query)
    end

  private
    def api
      @api ||= begin
        skype_service = bus.service(SKYPE_SERVICE)
        skype_object  = skype_service.object(CLIENT_TO_SKYPE_PATH)
        skype_object.introspect
        skype_object[SKYPE_SERVICE]
      end
    end

    def bus
      DBus::SessionBus.instance
    end
  end
end
