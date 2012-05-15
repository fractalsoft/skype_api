# coding: utf-8
require 'skype_api/chat_message'

describe SkypeApi::ChatMessage do
  let(:message) { SkypeApi::ChatMessage.new(1234) }

  it "exist" do
    message.should be
  end

  it "have id" do
    message.instance_variables.should include(:@id)
  end

  it "have not empty id" do
    message.id.should be
    message.id.should_not == ""
  end

  it "create new with id 1234" do
    message.id.should == 1234
  end

  it "have status, body, chatname" do
    message.instance_variables.should include(:@status, :@body, :@chatname)
  end

  it "have access to read status, body, chatname" do
    SkypeApi::ChatMessage.public_instance_methods.should include(:status, :body, :chatname)
  end

  [:status, :body, :chatname].each do |item|
    it "return API query for #{item}" do
      (message.send "get_#{item}".to_sym).should == "GET CHATMESSAGE 1234 #{item.to_s.upcase}"
    end
  end

  it "update his own atributes" do
    message.update("CHATMESSAGE 1234 BODY bot.fractalsoft Hello world!").body.should == "bot.fractalsoft Hello world!"
  end

  it "not update unknown chatmessage id" do
    message.update("CHATMESSAGE 9999 BODY bot.fractalsoft Hello world!").body.should be_nil
  end

  it "not update atributes which don't know" do
    message.update("CHATMESSAGE 1234 BODYY bot.fractalsoft Hello world!").body.should be_nil
  end

   it "generate API query FIFO to update chatmessage propertices" do
    message.fifo.should include("GET CHATMESSAGE 1234 STATUS", "GET CHATMESSAGE 1234 BODY",
                                "GET CHATMESSAGE 1234 CHATNAME")
  end

  it "show his own inside" do
    message.to_s.should == "<id = 1234, chatname = nil, body = nil, status = nil>"
  end

  it "reply for message if know body, chatname and status == received" do
    message.instance_variable_set :@chatname, "#bot.fractalsoft/$fractalsoft;232295f0a5417a7b"
    message.instance_variable_set :@body, "Hello world!"
    message.instance_variable_set :@status, "RECEIVED"
    msg = "CHATMESSAGE #bot.fractalsoft/$fractalsoft;232295f0a5417a7b Hello world!"
    message.reply.should == msg
  end

  it "not reply for message when body or chatname or stasus is nil" do
    message.reply.should be_nil
    message.instance_variable_set :@chatname, "#bot.fractalsoft/$fractalsoft;232295f0a5417a7b"
    message.reply.should be_nil
    message.instance_variable_set :@body, "Hello world!"
    message.reply.should be_nil
  end

  it "not reply when status != received" do
    message.instance_variable_set :@chatname, "#bot.fractalsoft/$fractalsoft;232295f0a5417a7b"
    message.instance_variable_set :@body, "Hello world!"
    message.instance_variable_set :@status, "SEND"
    message.reply.should be_nil
  end
end
