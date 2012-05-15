# coding: utf-8
require 'skype_api/user'

describe SkypeApi::User do
  let(:user) { SkypeApi::User.new("bot.fractalsoft") }

  it "create new" do
    user.should be
  end

  it "have name" do
    user.instance_variables.should include(:@name)
  end

  it "have not empty name" do
    user.name.should be
    user.name.should_not == ""
  end

  it "create new with name bot.fractalsoft" do
    user.name.should == "bot.fractalsoft"
  end

  it "have fullname, birthday, sex, language, province, city" do
    user.instance_variables.should include(:@fullname, :@birthday, :@sex, :@language, :@province, :@city)
  end

  it "have home, office and mobile phone" do
    user.instance_variables.should include(:@phone_home, :@phone_office, :@phone_mobile)
  end

  it "have homepage, about, buddystatus" do
    user.instance_variables.should include(:@homepage, :@about, :@buddystatus)
  end

  it "have constants with buddystatus" do
    SkypeApi::User.constants.should include(:NOT_IN_CONTACT, :DELETE_FROM_CONTACT, :AUTHORISATION_PENDING, :ADD_TO_CONTACT)
  end

  it "have access to read fullname, birthday, sex, language, province, city" do
    SkypeApi::User.public_instance_methods.should include(:fullname, :birthday, :sex, :language, :province, :city)
  end

  it "have access to read home, office and mobile phone" do
    SkypeApi::User.public_instance_methods.should include(:phone_home, :phone_office, :phone_mobile)
  end

  it "have access to read homepage, about, buddystatus" do
    SkypeApi::User.public_instance_methods.should include(:homepage, :about, :buddystatus)
  end

  [:fullname, :birthday, :sex, :language, :province, :city].each do |item|
    it "return API query for #{item}" do
      (user.send "get_#{item}".to_sym).should == "GET USER bot.fractalsoft #{item.to_s.upcase}"
    end
  end

  [:phone_home, :phone_office, :phone_mobile].each do |item|
    it "return API query for #{item}" do
      (user.send "get_#{item}".to_sym).should == "GET USER bot.fractalsoft #{item.to_s.upcase}"
    end
  end

  [:homepage, :about, :buddystatus].each do |item|
    it "return API query for #{item}" do
      (user.send "get_#{item}".to_sym).should == "GET USER bot.fractalsoft #{item.to_s.upcase}"
    end
  end

  it "update his own atributes" do
    user.update("USER bot.fractalsoft BUDDYSTATUS 3").buddystatus.should == 3
  end

  it "not update unknown user atributes" do
    user.update("USER not_fractalsoft BUDDYSTATUS 3").buddystatus.should be_nil
  end

  it "not update atributes which don't know" do
    user.update("USER bot.fractalsoft BUDDYSTAT 3").buddystatus.should be_nil
  end

  it "show his own inside" do
    text = '<name = "bot.fractalsoft", fullname = nil, birthday = nil, sex = nil, language = nil, '
    text << 'province = nil, city = nil, phone_home = nil, phone_office = nil, '
    text << 'phone_mobile = nil, homepage = nil, about = nil, buddystatus = nil>'
    user.to_s.should == text
  end

  it "return array with his propertices" do
    user.get(:name, :fullname, :about).should == ["bot.fractalsoft", nil, nil]
  end

  it "generate API query FIFO to update user propertices" do
    user.fifo.should include("GET USER bot.fractalsoft FULLNAME", "GET USER bot.fractalsoft BIRTHDAY",
                          "GET USER bot.fractalsoft SEX", "GET USER bot.fractalsoft LANGUAGE",
                          "GET USER bot.fractalsoft PROVINCE", "GET USER bot.fractalsoft CITY",
                          "GET USER bot.fractalsoft PHONE_HOME", "GET USER bot.fractalsoft PHONE_OFFICE",
                          "GET USER bot.fractalsoft PHONE_MOBILE", "GET USER bot.fractalsoft HOMEPAGE",
                          "GET USER bot.fractalsoft ABOUT", "GET USER bot.fractalsoft BUDDYSTATUS")
  end

  it "have method to authorisation" do
    user.authorisation.should == "SET USER bot.fractalsoft BUDDYSTATUS 2"
  end
end
