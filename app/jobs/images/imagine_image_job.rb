module Images
  class ImagineImageJob < ApplicationJob
    queue_as :default
    include SettingsHelper

    def perform(image:)
      prompts = image.story.sub_topic.prompts
      prompt_extra = s("prompts.#{prompts}.midjourney.prompt_extra")

      create_imagination(image, prompt_extra, :card, "2:1") if image.card_imagination.blank?
      create_imagination(image, prompt_extra, :landscape, "176:100") if image.landscape_imagination.blank?
      create_imagination(image, prompt_extra, :portrait, "57:100") if image.portrait_imagination.blank?

      image.update(processed: true)
    end

    def create_imagination(image, prompt_extra, aspect_ratio, ratio_value)
      imagination = Imagination.create(image: image, aspect_ratio: aspect_ratio, status: :pending, message_uuid: SecureRandom.uuid)
      prompt = "#{image.idea} #{prompt_extra} --ar #{ratio_value}"

      begin
        payload = NextLeg.imagine(prompt: prompt, ref: imagination.message_uuid)
        imagination.update(payload: payload)
      rescue StandardError => _e
        image.update(invalid_prompt: true)
      end

      throttle_requests
    end

    def throttle_requests
      pending_imaginations = Imagination.where(status: :pending).count

      if ENV['DYNAMIC_THROTTLE']
        if pending_imaginations > 3
          puts "Sleeping for 220 seconds"
          sleep(220)
        elsif pending_imaginations > 2
          puts "Sleeping for 180 seconds"
          sleep(180)
        else
          puts "Sleeping for 120 seconds"
          sleep(120)
        end
      else
        puts "Sleeping for 60 seconds"
        sleep(60)
      end
    end
  end
end
