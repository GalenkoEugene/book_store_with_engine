class Image < ApplicationRecord
  mount_uploader :file, ImagesUploader
  belongs_to :book
  validates :file, presence: true
end
