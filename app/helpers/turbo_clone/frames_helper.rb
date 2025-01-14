module TurboClone::FramesHelper
  def turbo_frame_tag(resource, &block)
    # to_key -> Returns an Array of all key attributes if any of the attributes is set
    #
    # The DOM id convention is to use the singular form of an object or class with the id following
    # an underscore. If no id is found, prefix with “new_” instead.
    id = resource.respond_to?(:to_key) ? dom_id(resource) : resource

    # We are passing the html included between turbo-frame as block
    tag.turbo_frame(id: id, &block)
  end
end