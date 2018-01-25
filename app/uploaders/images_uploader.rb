# require 'mini_magick'

# Photo uloader for Books
class ImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog
  process resize_to_fit: [350, 350]

  def store_dir
    return 'dev' if Rails.env.development?
    'shop/images'
  end

  def cache_dir
    "#{Rails.root}/tmp/cache/images"
  end

  version :thumb do
    process resize_to_limit: [50, 60]
  end

  version :catalog_size do
    process resize_to_limit: [160, 250]
  end

  version :view_size do
    process resize_to_limit: [555, 380]
  end

  version :slider_size do
    process resize_to_limit: [250, 400]
  end

  def extension_whitelist
    %w[jpg jpeg gif png bmp]
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def secure_token
    media_filenames = :"@#{mounted_as}_original_filenames"

    unless model.instance_variable_get(media_filenames)
      model.instance_variable_set(media_filenames, {})
    end

    unless model.instance_variable_get(media_filenames).map { |k, _v| k }.include? original_filename.to_sym
      new_value = model.instance_variable_get(media_filenames)
                       .merge("#{original_filename}": SecureRandom.uuid)
      model.instance_variable_set(media_filenames, new_value)
    end

    model.instance_variable_get(media_filenames)[original_filename.to_sym]
  end
end
