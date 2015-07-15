class User < ActiveRecord::Base
  before_save { email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates :name, presence: true, length: { maximum: Settings.namemax }
  validates :email, presence: true, length: { maximum: Settings.emailmax },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 1 }, allow_nil: true
  mount_uploader :avatar, PictureUploader
  validate :avatar_size

  # Returns the hash digest of the given string.
  def User.digest string 
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  private
  def avatar_size
    if avatar.size > Settings.avatar_size.megabytes
      errors.add :avatar, t("picture_error")
    end
  end
end
