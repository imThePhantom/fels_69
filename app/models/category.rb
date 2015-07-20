class Category < ActiveRecord::Base
  has_many :words, dependent: :destroy
  has_many :lessons, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.namemax}, uniqueness: true
  validates :description, length: {maximum: Settings.descriptionmax}
  mount_uploader :picture, PictureUploader

  private
  def picture_size
   errors.add :picture, t("picture_error") if picture.size > Settings.picture_size.megabytes
  end

end
