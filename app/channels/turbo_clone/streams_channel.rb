class TurboClone::StreamsChannel < ActionCable::Channel::Base
  extend TurboClone::Streams::StreamName, TurboClone::Streams::Broadcasts

  def subscribed
    # <turbo-cable-stream-source channel="TurboClone::StreamsChannel" signed-stream-name='articles'>
    stream_from params[:signed_stream_name]
  end
end



