require 'mechanize'
require 'digest/sha1'

def smart_www_action(&blk)
	attempts = 10
	begin
		blk.call
	rescue Mechanize::ResponseCodeError => e
		if e.response_code == "404"
			raise e
		else
			attempts -= 1
			if attempts <= 0
				raise e
			else
				retry
			end
		end
	rescue => e
		attempts -= 1
		if attempts <= 0
			raise e
		else
			retry
		end
	end
end

def get(www, *args)
  # debug
  #puts "GET in #{caller[0]}: #{args.inspect}"
	smart_www_action do
		www.get *args
	end
end

agent = Mechanize.new { |agent|
          agent.history.max_size=1
          agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
        }

url = 'http://www.cryptocoincharts.info/period-charts.php?period=alltime&resolution=day&pair=ltc-usd&market=btc-e'

page = get agent, url

trs = page.root.search('div[@class="container"]/div[@class="row"]/div[@class="span10"]/table[@class="table table-striped"]/tbody/tr')
File.open(ARGV[0], 'w') do |file|
  trs.each do |tr|
    tds = tr.search("td")
    date = tds[0].inner_text.strip.gsub(/-/, '')
    low   = tds[1].inner_text.gsub(/USD/, '').strip
    high  = tds[2].inner_text.gsub(/USD/, '').strip
    open  = tds[3].inner_text.gsub(/USD/, '').strip
    close = tds[4].inner_text.gsub(/USD/, '').strip
    volume = tds[5].inner_text.gsub(/LTC/, '').gsub(/,/, '').strip
    file.write("#{date} #{low} #{high} #{open} #{close} #{volume}\n")
  end
end

