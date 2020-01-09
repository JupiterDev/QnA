class Link < ApplicationRecord
  URL_FORMAT = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix.freeze
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true

  validates :url, format: { with: URL_FORMAT, multiline: true, message: "must be valid" }
end
