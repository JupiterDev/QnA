class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  default_scope -> { order(best: :desc) }

  belongs_to :user
  belongs_to :question

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  
  validates :body, presence: true

  def choose_the_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
      question.badge&.update!(user: user)
    end
  end
end
