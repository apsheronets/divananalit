require 'mechanize'

#agent = Mechanize.new { |agent|
#          agent.history.max_size=1
#          agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
#        }
#
#url = 'https://www.bitfinex.com/pages/stats'
#
#page = agent.get url

# Fucking bitfinex added Web3.99 shit-tastic JS-based SaaS DoS-protection
# using fucking selenium
# it's 2014 and I couldn't just download fucking HTML
# holy fuck

require 'rubygems'
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :firefox
driver.get "https://www.bitfinex.com/pages/stats"

#page = Nokogiri::HTML(driver.page_source)
# bitfinex hided the data into <!-- -->
commented_part = driver.page_source.match(/<!--\s*<h4>Bitfinex Sentiment Index<\/h4>(.*)-->/m)[1]
page = Nokogiri::HTML(commented_part)

driver.quit

green = page.root.search('div[@class="progress large-12 success radius"]/span').first.attributes['style'].value.match(/width:\s*([0-9.]+)%/)[1].to_f
red = page.root.search('div[@class="progress large-12 red secondary radius"]/span').first.attributes['style'].value.match(/width:\s*([0-9.]+)%/)[1].to_f
unixtime = DateTime.now.strftime("%s")

file = ARGV[0]

File.open(file, 'a+', 0644) do |f|
  f.flock(File::LOCK_EX)
  f.write "#{unixtime} #{green} #{red}\n"
  f.flush
end

