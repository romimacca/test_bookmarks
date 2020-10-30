class Category < ApplicationRecord
    belongs_to :parent, class_name: "Category", optional: true, foreign_key: :category_id
    has_many :children, class_name: 'Category', dependent: :nullify

    has_many :bookmarks, dependent: :nullify

end
