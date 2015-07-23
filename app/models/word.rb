class Word < ActiveRecord::Base
  belongs_to :category
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true,
    reject_if: proc {|a| a[:content].blank?}
  validates :content, presence: true, uniqueness: true
  validate :check_correct_answer

  private
  def check_correct_answer
    errors.add :base, I18n.t("not_choice_correct") if answers.select{|opt| opt.correct}.blank?
  end

end
