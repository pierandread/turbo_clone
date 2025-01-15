module TurboClone::StreamsHelper
  def turbo_stream
    # passing view context to generate html with render
    TurboClone::Streams::TagBuilder.new(self)
  end
end