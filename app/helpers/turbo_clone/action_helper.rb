module TurboClone::ActionHelper
  # it will generate
  # <turbo-stream target=<%= dom_id(@article) %> action="replace">
  # <template>
  # <%= render partial: "articles/article", locals: {article: @article}, formats: :html %>
  #   </template>
  # </turbo-stream>
  def turbo_stream_action_tag(action, target:, template:)
    template = action == :remove ? "" : "<template>#{template}</template>"

    if target = convert_to_turbo_stream_dom_id(target)
      %(<turbo-stream action="#{action}" target="#{target}">#{template}</turbo-stream>).html_safe
    else
      raise ArgumentError, "target must be supplied"
    end
  end

  def convert_to_turbo_stream_dom_id(target)
    if target.respond_to?(:to_key)
      ActionView::RecordIdentifier.dom_id(target)
    else
      target
    end
  end
end