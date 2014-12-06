require_relative "chinchilla_downloader"

class ImageDownloader

  @@sizes = []

  def initialize *imgs
    @imgs = imgs
  end

  def download
    chinchillas.each { |chd| perform_download(chd) unless file_exists?(chd) }    
  end

  private

  def chinchillas
    @imgs.map { |img| ChinchillaDownloader.new(img) }
  end

  def perform_download chd
    size = chd.download
    additional_check size, chd
  end

  def file_exists? chd
    File.exist? "#{chd.image_folder_path}/#{chd.image_name}"
  end

  def additional_check size, chd
    if @@sizes.include? size
      `rm #{chd.image_folder_path}/#{chd.image_name}`
    else
      @@sizes << size
    end
  end

end
