require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations
require "YAML"
describe "Testt" do

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
  
  it "test_t" do
    @driver.get(@base_url + "/home")
    @driver.find_element(:id, "member_email").clear
    @driver.find_element(:id, "member_email").send_keys "sukada.testmember1@socialmedialink.com"
    @driver.find_element(:id, "member_password").click
    @driver.find_element(:id, "member_password").clear
    @driver.find_element(:id, "member_password").send_keys "general1234"
    @driver.find_element(:name, "commit").click
    @driver.find_element(:link, "New Activity").click
    @driver.find_element(:xpath, "//div/span").click
    @driver.find_element(:link, "Add post").click
    @driver.find_element(:id, "shares__text").clear
    @driver.find_element(:id, "shares__text").send_keys "thhehe"
    @driver.find_element(:xpath, "//button[@type='submit']").click
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
