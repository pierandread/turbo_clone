module TurboClone::Streams::StreamName
  def stream_name_from(streamables)
    if streamables.is_a?(Array)
      streamables.map{ |streamable| stream_name_from(streamable) }.join(":")
    else
      # then just to convert name to singular
      streamables.then do |streamable|
        streamable.respond_to?(:to_key) ? ActionView::RecordIdentifier.dom_id(streamable) : streamable
      end
    end
  end
end