class Question < ApplicationRecord
  belongs_to :user

  has_many_attached :files

  has_many :answers, dependent: :destroy
  validates :title, :body, presence: true
end
