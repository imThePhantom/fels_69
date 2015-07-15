class User < ActiveRecord::Base
  attr_accessor :remember_token
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

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token 
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attributes remember_digest: nil
  end  

  private
    def avatar_size
      if avatar.size > Settings.avatar_size.megabytes
        errors.add :avatar, t("picture_error")
      end
    end
end
