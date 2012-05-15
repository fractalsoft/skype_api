# coding: utf-8
require 'logger'

module SkypeApi
  class Client
    attr_reader :fifo, :profile, :users_list, :msg_list, :logger
    attr_accessor :auto_authorize

    def self.instance
      @instance ||= new
    end

    def proxy(text)
      @logger.info(">> #{text}")
      destination, target = text.split
      destination = destination.downcase.to_sym
      case destination
        when :currentuserhandle
          @profile = Profile.new(target)
          @fifo += @profile.fifo
        when :user
          user_redirect(target, text)
        when :chatmessage
          msg_redirect(target.to_i, text)
        when :profile
          profile_redirect(text)
      end
      @logger.info("<< #{fifo[0]}")
      # FIXME not for testing, only for Skype mode
      if ENV['_'].match(/rspec$/).nil?
        proxy(invoke_query[0])
      end
    end

  private
    def initialize
      @users_list = {}
      @auto_authorize = true
      @profile = nil
      @fifo = []
      @msg_list = {}
      @logger = Logger.new('log/skype_api.log')
      # @logger = Logger.new(STDOUT)
      # log.level = Logger::WARN
    end

    def user_redirect(target, text)
      if @users_list.has_key? target
        @users_list[target].update(text)
      elsif is_authorize?(text)
        @users_list[target] = User.new(target)
        @fifo << @users_list[target].authorisation
        @fifo += @users_list[target].fifo
      end
    end

    def msg_redirect(target, text)
      if @msg_list.has_key? target
        @msg_list[target].update(text)
        @fifo.push(@msg_list[target].reply).compact!
      else
        @msg_list[target] = ChatMessage.new(target)
        @fifo += @msg_list[target].fifo
      end
    end

    def profile_redirect(text)
      @profile.update(text)
    end

    def invoke_query
      SkypeApi::Api.instance.invoke(@fifo.shift) unless @fifo.empty?
    end

    def is_authorize?(text)
      @auto_authorize
    end
  end
end
