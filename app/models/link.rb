class Link < ApplicationRecord
  belongs_to :user
  validates_with UrlValidator
end
