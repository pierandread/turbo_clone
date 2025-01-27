module TurboClone::StreamsHelper
  def turbo_stream
    # passing view context to generate html with render
    TurboClone::Streams::TagBuilder.new(self)
  end

  def turbo_stream_from(*streamables, **attributes)
    attributes[:channel] = TurboClone::StreamsChannel
    attributes[:"signed-stream-name"] = TurboClone::StreamsChannel.stream_name_from(streamables)

    tag.turbo_cable_stream_source(**attributes)
  end
end