require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations
require "YAML"

describe "SukadaScripts" do

  before(:each) do
    @config = YAML.load_file("config_smiley.yml")
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "https://febtest-staging.socialmedialink.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    #@driver.quit
    @verification_errors.should == []
  end
  
  it "test_sukada_scripts" do
    @driver.get(@base_url + "/home")
    @driver.find_element(:id, "member_email").clear
    @driver.find_element(:id, "member_email").send_keys "sukada.testmember1@socialmedialink.com"
    @driver.find_element(:id, "member_password").clear
    @driver.find_element(:id, "member_password").send_keys "general1234"
    @driver.find_element(:name, "commit").click
    @driver.find_element(:link, "survey").click
    @driver.find_element(:xpath, "//div/span").click
    @driver.find_element(:link, "Start survey").click
    @driver.find_element(:id, "radio_text_34762_0").click
    @driver.find_element(:css, "label.control-radio.ng-binding").click
    @driver.find_element(:css, "button.btn.button").click
    @driver.find_element(:id, "radio_text_34763_0").click
    @driver.find_element(:css, "label.control-radio.ng-binding").click
    @driver.find_element(:css, "button.btn.button").click
    @driver.find_element(:link, "Dashboard").click
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
