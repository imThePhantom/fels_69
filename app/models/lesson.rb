class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :results, dependent: :destroy
  accepts_nested_attributes_for :results

  after_create :init_result
  before_save :correct_count
  validate :check_word, on: :create

  default_scope -> { order(created_at: :desc) }

  def correct_count
    results.select{|result| result.answer.try(:correct?)}.count
  end

  def time_remain
    self.point = self.results
      .count*Settings.time_per_word - (Time.zone.now - self.created_at).to_i
  end

  private
  def init_result
    self.category.words.not_learned(self.user).random_words.each do |word|
      self.results.create word_id: word.id
    end
  end

  def check_word
    @words = self.category.words.not_learned(self.user).random_words
    if @words.count < Settings.min_word_per_lesson
      errors.add :base, I18n.t("not_enough_word")
    end
  end
end

