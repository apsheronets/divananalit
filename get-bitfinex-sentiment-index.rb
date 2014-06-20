require 'mechanize'

agent = Mechanize.new { |agent|
          agent.history.max_size=1
          agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
        }

url = 'https://www.bitfinex.com/pages/stats'

page = agent.get url

green = page.root.search('div[@class="progress large-12 success radius"]/span').first.attributes['style'].value.match(/width:\s*([0-9.]+)%/)[1].to_f
red = page.root.search('div[@class="progress large-12 red secondary radius"]/span').first.attributes['style'].value.match(/width:\s*([0-9.]+)%/)[1].to_f
unixtime = DateTime.now.strftime("%s")

file = ARGV[0]

File.open(file, 'a+', 0644) do |f|
  f.flock(File::LOCK_EX)
  f.write "#{unixtime} #{green} #{red}\n"
  f.flush
end

