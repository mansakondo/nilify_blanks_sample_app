class Post < ApplicationRecord
  attribute :tags, :nilify_blanks, type: [:string]
  attribute :metadata, :nilify_blanks, type: :hstore
end
