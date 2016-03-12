require 'rubygems'
require 'mechanize'
require 'bigdecimal'
require 'selenium-webdriver'

def get_price(symbol)

  agent = Mechanize.new do |agent|
    agent.history.max_size = 1
    agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  url = 'https://api.bitfinex.com/v1/pubticker/' + symbol.to_s
  #p url

  json = JSON.parse(agent.get(url).body)

  json['last_price'].to_f

end

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

driver = Selenium::WebDriver.for :firefox
driver.get "https://www.bitfinex.com/pages/stats"

page = Nokogiri::HTML(driver.page_source)

driver.quit

table = page.at('h5:contains("Rates on Margin Funding")').next.next.next.next

trs = table.search('tbody/tr')

long_currency = 'usd'
hash = {}

trs.each do |tr|
  tds = tr.search("td")
  currency = tds[0].inner_text.strip.downcase
  frr      = tds[1].inner_text.gsub(/%/, '').strip.to_f
  amf      = tds[2].inner_text.gsub(/,/, '').strip.to_f
  umf      = BigDecimal.new tds[3].inner_text.gsub(/,/, '').strip
  if currency != long_currency
    price = get_price(currency + 'usd')
    umf_value = price * umf
  else
    price = 1
    umf_value = umf
  end
  #print "#{currency} #{frr} #{amf} #{umf.to_f} #{umf_value.to_f} #{price}\n"
  hash[currency] = { frr: frr, amf: amf, umf: umf, umf_value: umf_value }
end
#p hash

longs = hash[long_currency][:umf_value]
shorts = hash.select{|key,_|key!=long_currency}.reduce(0){|acc, (k,v)| acc + v[:umf_value]}
total_umf = hash.reduce(0){|acc, (k,v)| acc + v[:umf_value]}
bsi2 = ((longs / (longs + shorts)) * 100.0)

#printf "%f\n", longs
#printf "%f\n", shorts
#printf "%f\n", total_umf

#printf "%f\n", bsi2

unixtime = DateTime.now.strftime("%s")

path = ARGV[0]

hash.each do |k,v|

  file = File.join(path, ('margin-stats-' + k + '.dat'))

  File.open(file, 'a+', 0644) do |f|
    f.flock(File::LOCK_EX)
    f.write "#{unixtime} #{v[:frr]} #{v[:amf].to_f} #{v[:umf].to_f} #{v[:umf_value].to_f}\n"
    f.flush
  end

end

file = File.join(path, 'bsi2.dat')

File.open(file, 'a+', 0644) do |f|
  f.flock(File::LOCK_EX)
  f.write "#{unixtime} #{bsi2.to_f} #{total_umf.to_f}\n"
  f.flush
end

