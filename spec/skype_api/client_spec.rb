# coding: utf-8
require 'skype_api'

describe SkypeApi::Client do
  let(:client) { SkypeApi::Client.instance }

  it "instance exist" do
    client.should be
  end

  it "have list of user" do
    (client.instance_variable_defined? :@users_list).should be_true
  end

  it "users_list is a hash" do
    (client.instance_variable_get :@users_list).should be_an_instance_of(Hash)
  end

  it "have property auto_authorize" do
    (client.instance_variable_defined? :@auto_authorize).should be_true
  end

  it "have auto_authorize turn on" do
    client.auto_authorize.should be_true
  end

  it "have proxy method which separate query" do
    (SkypeApi::Client.method_defined? :proxy).should be_true
  end

  it "have client profile" do
    (client.instance_variable_defined? :@profile).should be_true
  end

  it "have fifo for query" do
    (client.instance_variable_defined? :@fifo).should be_true
  end

  it "fifo is an array" do
    (client.instance_variable_get :@fifo).should be_an_instance_of(Array)
  end

  it "proxy redirect to profil when receive appropriately msg" do
    client.proxy("CURRENTUSERHANDLE bot.fractalsoft")
    client.fifo.should have_at_least(2).items
    (client.instance_variable_get :@profile).should be_an_instance_of(SkypeApi::Profile)
    client.profile.name.should == "bot.fractalsoft"
  end

  it "proxy redirect to user when receive appropriately msg - user don't exist" do
    client.proxy("USER bot.fractalsoft RECEIVEDAUTHREQUEST my msg")
    client.users_list.should have_at_least(1).items
    client.users_list["bot.fractalsoft"].should be_an_instance_of(SkypeApi::User)
    client.users_list["bot.fractalsoft"].name.should == "bot.fractalsoft"
    client.fifo.should have_at_least(2).items
    client.fifo.should include("SET USER bot.fractalsoft BUDDYSTATUS 2")
  end

  it "proxy redirect to user when receive appropriately msg - user exist" do
    client.instance_variable_set :@users_list, {"bot.fractalsoft" => SkypeApi::User.new("bot.fractalsoft")}
    client.proxy("USER bot.fractalsoft FULLNAME Fractal Soft")
    client.users_list.should have(1).items
    client.users_list["bot.fractalsoft"].fullname.should == "Fractal Soft"
  end

  it "have property msg_list" do
    (client.instance_variable_defined? :@msg_list).should be_true
  end

  it "msg_list is a hash" do
    (client.instance_variable_get :@msg_list).should be_an_instance_of(Hash)
  end

  it "proxy redirect to chatmessage when receive appropriately msg - chatmessage don't exist" do
    client.proxy("CHATMESSAGE 1234 STATUS RECEIVE")
    client.msg_list.should have(1).items
    client.msg_list[1234].should be_an_instance_of(SkypeApi::ChatMessage)
    client.msg_list[1234].id.should == 1234
    client.fifo.should have_at_least(2).items
  end

  it "proxy redirect to chatmessage when receive appropriately msg - chatmessage exist" do
    client.instance_variable_set :@msg_list, {1234 => SkypeApi::ChatMessage.new(1234)}
    client.proxy("CHATMESSAGE 1234 STATUS RECEIVE")
    client.msg_list.should have(1).items
    client.msg_list[1234].status.should == "RECEIVE"
  end

  it "proxy redirect to profile when receive appropriately msg" do
    client.proxy("PROFILE FULLNAME Fractal Soft")
    client.profile.fullname.should == "Fractal Soft"
  end

=begin
  it "proxy method invoke api query from fifo" do
    client.instance_variable_set :@fifo, ["GET USER bot.fractalsoft FULLNAME", "GET USER bot.fractalsoft BIRTHDAY",
                                          "GET USER bot.fractalsoft SEX",      "GET USER bot.fractalsoft LANGUAGE",
                                          "GET USER bot.fractalsoft PROVINCE", "GET USER bot.fractalsoft CITY"]
    expect{ client.proxy("test1") }.to change{ client.fifo.size }.from(6).to(5)
    expect{ client.proxy("test2") }.to change{ client.fifo.size }.from(5).to(4)
  end
=end

  it "have method which check if authorization is possible" do
    SkypeApi::Client.private_instance_methods.should include(:is_authorize?)
    (client.send :is_authorize?, "USER bot.fractalsoft RECEIVEDAUTHREQUEST").should be_true
  end

  it "authorize User when variable auto_authorize is true" do
    client.instance_variable_set :@users_list, {}
    client.proxy("USER bot.fractalsoft RECEIVEDAUTHREQUEST")
    client.users_list.should have(1).items
  end

  it "not authorize User when variable auto_authorize is false" do
    client.instance_variable_set :@users_list, {}
    client.auto_authorize = false
    client.proxy("USER bot.fractalsoft RECEIVEDAUTHREQUEST")
    client.users_list.should be_empty
  end

  it "have variable logger to add logs" do
    client.instance_variables.should include(:@logger)
    client.logger.should be_an_instance_of(Logger)
  end

  it "send reply for chatmessage" do
    chat_message = SkypeApi::ChatMessage.new(1234)
    chat_message.instance_variable_set :@body, "Hello world!"
    chat_message.instance_variable_set :@chatname, "#bot.fractalsoft/$fractalsoft;232295f0a5417a7b"
    client.instance_variable_set :@msg_list, {1234 => chat_message}
    client.proxy("CHATMESSAGE 1234 STATUS RECEIVED")
    client.fifo.should include "CHATMESSAGE #bot.fractalsoft/$fractalsoft;232295f0a5417a7b Hello world!"
  end
end
