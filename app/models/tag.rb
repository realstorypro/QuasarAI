# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :feed_items, through: :taggings
  has_many :feeds, through: :feed_items
  has_many :sub_topics, through: :feeds
end
