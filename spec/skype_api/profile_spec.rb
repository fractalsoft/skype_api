# coding: utf-8
require 'skype_api/profile'

describe SkypeApi::Profile do
  let(:profile) { SkypeApi::Profile.new }

  it "instance exist" do
    profile.should be
  end

  it "is child of User class" do
    profile.should be_a_kind_of(SkypeApi::User)
  end

  it "generate API query FIFO to update profile propertices" do
    profile.fifo.should include("GET PROFILE FULLNAME", "GET PROFILE BIRTHDAY",
                          "GET PROFILE SEX", "GET PROFILE LANGUAGE",
                          "GET PROFILE PROVINCE", "GET PROFILE CITY",
                          "GET PROFILE PHONE_HOME", "GET PROFILE PHONE_OFFICE",
                          "GET PROFILE PHONE_MOBILE", "GET PROFILE HOMEPAGE",
                          "GET PROFILE ABOUT", "GET PROFILE BUDDYSTATUS")
  end

  it "update his own atributes" do
    profile.update("PROFILE BUDDYSTATUS 3").buddystatus.should == 3
  end

  it "not update atributes which don't know" do
    profile.update("USER bot.fractalsoft BUDDYSTAT 3").buddystatus.should be_nil
  end

  [:fullname, :birthday, :sex, :language, :province, :city].each do |item|
    it "return API query for #{item}" do
      (profile.send "get_#{item}".to_sym).should == "GET PROFILE #{item.to_s.upcase}"
    end
  end

  [:phone_home, :phone_office, :phone_mobile].each do |item|
    it "return API query for #{item}" do
      (profile.send "get_#{item}".to_sym).should == "GET PROFILE #{item.to_s.upcase}"
    end
  end

  [:homepage, :about, :buddystatus].each do |item|
    it "return API query for #{item}" do
      (profile.send "get_#{item}".to_sym).should == "GET PROFILE #{item.to_s.upcase}"
    end
  end

  it "show his own inside" do
    text = '<name = "", fullname = nil, birthday = nil, sex = nil, language = nil, '
    text << 'province = nil, city = nil, phone_home = nil, phone_office = nil, '
    text << 'phone_mobile = nil, homepage = nil, about = nil, buddystatus = nil>'
    profile.to_s.should == text
  end
end
