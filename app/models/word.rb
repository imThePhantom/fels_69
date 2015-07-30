class Word < ActiveRecord::Base
  belongs_to :category
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true,
    reject_if: proc {|a| a[:content].blank?}
  validates :content, presence: true, uniqueness: true
  validate :check_correct_answer

  scope :search, ->search{where "content LIKE ?", "%#{search}%"}
  scope :alphabet, ->{order "content ASC"}
  scope :filter_category, ->category{where category_id: category if category.present?}
  scope :learned, ->user{where "id IN (SELECT word_id FROM results WHERE lesson_id IN 
    (SELECT id FROM lessons WHERE user_id = ?) AND answer_id IN 
    (SELECT id FROM answers WHERE correct = 't'))", user.id}
  scope :not_learned, ->user{where "id NOT IN (SELECT word_id FROM results WHERE lesson_id IN 
    (SELECT id FROM lessons WHERE user_id = ?) AND answer_id IN 
    (SELECT id FROM answers WHERE correct = 't'))", user.id}
  scope :get_all, ->user{}
  scope :random_words, ->{order "RANDOM() LIMIT #{Settings.max_word_per_lesson}"}

  private
  def check_correct_answer
    errors.add :base, I18n.t("not_choice_correct") if answers.select{|opt| opt.correct}.blank?
  end

end
