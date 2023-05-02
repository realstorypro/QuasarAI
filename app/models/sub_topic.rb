# == Schema Information
#
# Table name: sub_topics
#
#  id         :bigint           not null, primary key
#  name       :string
#  topic_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  feed       :string
#
class SubTopic < ApplicationRecord
  belongs_to :topic
  has_one :feed, dependent: :destroy
end
