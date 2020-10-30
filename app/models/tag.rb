class Tag < ApplicationRecord
    has_many :bookmarks, dependent: :nullify
end
