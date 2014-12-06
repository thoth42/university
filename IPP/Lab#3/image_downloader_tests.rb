require_relative 'image_downloader.rb'

`rm ./images/*`

ImageDownloader.new("8rsVbPp").download
if File.exist?("./images/8rsVbPp.jpg")
  puts "You have a 6!"
else
  puts "Could not find image ./images/8rsVbPp.jpg !"
end

ImageDownloader.new("YeQ7JzC", "9kJXp83").download
if File.exist?("./images/YeQ7JzC.jpg") and File.exist?("./images/9kJXp83.jpg")
  puts "You have a 7!"
else
  puts "Could not find images ./images/8rsVbPp.jpg and ./images/9kJXp83.jpg!"
end

ImageDownloader.new("AIS0Ete").download
time = File.mtime("./images/AIS0Ete.jpg")
sleep(1)
ImageDownloader.new("AIS0Ete").download
if File.mtime("./images/AIS0Ete.jpg") == time
  puts "You have an 8!"
else
  puts "The image has been downloaded again! How sad for the traffic!"
end


ImageDownloader.new("0Wtm4iq").download
time = File.mtime("./images/0Wtm4iq.jpg")
sleep(1)
ImageDownloader.new("0Wtm4iq", "AIlL6Wk").download
if File.mtime("./images/0Wtm4iq.jpg") == time and File.exist?("./images/AIlL6Wk.jpg")
  puts "You have a 9!"
else
  puts "The image 0Wtm4iq has been downloaded again!"
end

ImageDownloader.new("0uTsMuZ").download
time = File.mtime("./images/0uTsMuZ.jpg")
sleep(1)
ImageDownloader.new("mm6W3da").download

if File.mtime("./images/0uTsMuZ.jpg") == time and not File.exist?("./images/mm6W3da.jpg")
  puts "You have a 10!"
else
  puts "The images are equal, but they both have been downloaded!"
end
