# A simple facebook public videos downloader in ruby
# © Ezz-Kun ft Datez-kun 2020
# date : (2020-09-15 23:25:59)

require 'httparty'

def save_video(biner,name)
	path = "result"
	if Dir.exists?(path) == false
		Dir.mkdir(path)
	end
	out = File.new("#{path}/#{name}","wb")
	out.write(biner)
	out.close
	puts " [^] saving #{name}"
end

def get_video(page)
	begin
		rel = page.match('hd\_src\:"(.*?)"')[1]
	rescue NoMethodError
		puts " something error!"
	end
	if rel
		name = rel.match("/\(\\d.*?\_\\d.+\.mp4)")[1]
	end
	save_video(HttpPage(rel),name)
end	

def HttpPage(url)
	begin
		return HTTParty.get(url)
	rescue SocketError
		puts " [^] no internet connection!"
	end
end

def Main(url_file)
	puts "\n [^] Wait a few seconds...."
	if url_file.include? "https://"
		get_video(HttpPage(url_file))
		puts " [^] all done, video saved in ``result``\n\n"
	else
		doc = File.open(url_file)
		all = doc.read.split("\n")
		for cek in all do
			get_video(HttpPage(cek))
		end
		puts " [^] all done, #{all.length} videos saved in ``result``\n\n"
	end
end

if (ARGV.length) < 1
	puts " Usage : fb-dl.rb [ url ] / [ file ]"
else
	Main(ARGV[0])
end
