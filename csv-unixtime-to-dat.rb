require 'date'
lines = File.readlines(ARGV[0])
lines = lines.map do |line|
  l = line.split(',')
  l[1] = DateTime.strptime(l[1],'%s').strftime("%Y%m%d")
  line = l.join(' ')
end
File.open(ARGV[1], 'w') do |file|
  file.puts lines
end
