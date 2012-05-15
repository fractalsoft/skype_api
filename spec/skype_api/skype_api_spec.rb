# coding: utf-8
require 'skype_api/skype_api'

describe SkypeApi do
  it "have services and paths constans" do
    SkypeApi.constants.should include(:SERVICE, :SKYPE_TO_CLIENT_PATH, :CLIENT_INTERFACE,
                                      :CLIENT_TO_SKYPE_PATH, :SKYPE_SERVICE)
  end

  describe "::Api" do
    it "have instance" do
      SkypeApi::Api.instance.should be
    end

    # Test below needs a Skype connection.
    # Add key "SkypeApi" to Skype public API.
    it "have attach method with 2 arguments which return true" do
      (SkypeApi::Api.instance.attach(7, "SkypeApi")).should be_true
      SkypeApi::Api.instance.instance_variables.should include(:@is_on)
    end

    it "have method invoke for API query" do
      SkypeApi::Api.instance.should respond_to(:invoke).with(1).arguments
    end
  end

  describe "::Notify" do
    it "have DBus subclass" do
      SkypeApi::Notify.new("/com/Skype/Client").should be_a_kind_of(DBus::Object)
    end

  end
end
