# coding: utf-8
require 'skype_api/msg_request'

describe SkypeApi::MsgRequest do
  it "exist" do
    SkypeApi::MsgRequest.should be
  end

  it "reply for user message" do
    SkypeApi::MsgRequest.reply("Hello world!").should == "Hello world!"
  end
end
