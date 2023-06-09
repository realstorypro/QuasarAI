# == Schema Information
#
# Table name: feeds
#
#  id           :bigint           not null, primary key
#  sub_topic_id :bigint           not null
#  payload      :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  processed    :boolean          default(FALSE)
#  error        :boolean          default(FALSE)
#
FactoryBot.define do
  factory :feed do
    sub_topic
    payload { { some_key: Faker::Lorem.word, another_key: Faker::Lorem.sentence } }
    created_at { Faker::Time.between(from: 30.days.ago, to: Time.zone.today) }
    updated_at { created_at }
    processed { false }
    error { false }
  end
end
