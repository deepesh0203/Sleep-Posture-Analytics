class ImageUpdatesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "image_updates"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
