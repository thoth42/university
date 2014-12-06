require 'open-uri'

class ChinchillaDownloader
  DEFAULT_BASE_URL = "http://i.imgur.com"
  attr_accessor :image_folder_path, :base_url

  def initialize(uri)
    @base_url = DEFAULT_BASE_URL
    @image_folder_path = "./images"
    @image_uri = uri
  end

  def image_name
    @image_uri + ".jpg"
  end

  def download
    File.open("#{image_folder_path}/#{image_name}", "wb+") do |fo|
      fo.write open("#{base_url}/#{image_name}").read
    end
  end
end

