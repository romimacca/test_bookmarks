class Bookmark < ApplicationRecord
  belongs_to :tag, optional: true
  belongs_to :category, optional: true
end
