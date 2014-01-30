require 'mechanize'

agent = Mechanize.new { |agent|
          agent.history.max_size=1
          agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
        }

url = 'http://www.cryptocoincharts.info/period-charts.php?period=alltime&resolution=day&pair=btc-usd&market=btc-e'

page = agent.get url

trs = page.root.search('div[@class="container"]/div[@class="row"]/div[@class="span10"]/table[@class="table table-striped"]/tbody/tr')
trs.each do |tr|
  tds = tr.search("td")
  date = tds[0].inner_text.strip.gsub(/-/, '')
  low   = tds[1].inner_text.gsub(/,/, '').gsub(/USD/, '').strip
  high  = tds[2].inner_text.gsub(/,/, '').gsub(/USD/, '').strip
  open  = tds[3].inner_text.gsub(/,/, '').gsub(/USD/, '').strip
  close = tds[4].inner_text.gsub(/,/, '').gsub(/USD/, '').strip
  volume = tds[5].inner_text.gsub(/LTC/, '').gsub(/,/, '').strip
  print "#{date} #{low} #{high} #{open} #{close} #{volume}\n"
end
