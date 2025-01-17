class TurboClone::Streams::TagBuilder
  def initialize(view_context)
    @view_context = view_context
    # ensuring that :html is included in the formats array for the render method
    @view_context.formats |= [:html]
  end

  # targer
  # <%= turbo_stream.replace @article %>
  # or **rendering
  # <%= turbo_stream.replace @article, partial: "articles/article", locals: { article: @article } %>
  # or &block
  # <%= turbo_stream.replace @article do %>
  #   <%= render @article %>
  # <% end %>
  # or "content"
  # <%= turbo_stream.replace @article, "Hello world" %>
  def replace(target, content = nil, **rendering, &block)
    action :replace, target, content, **rendering, &block
  end

  def update(target, content = nil, **rendering, &block)
    action :update, target, content, **rendering, &block
  end

  def prepend(target, content = nil, **rendering, &block)
    action :prepend, target, content, **rendering, &block
  end

  def remove(target, content = nil, **rendering, &block)
    action :remove, target
  end

  private

  def action(name, target, content = nil, **rendering, &block)
    #  <%= render partial: "articles/article", locals: {article: @article}, formats: :html %>
    template = render_template(target, content, **rendering, &block) unless name == :remove

    turbo_stream_action_tag(name, target: target, template: template)
  end

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

  def render_template(target, content = nil, **rendering, &block)
    if content
      # for case like <%= turbo_stream.prepend "articles", @article %>
      content.respond_to?(:to_partial_path) ? @view_context.render(partial: content, formats: :html) : content
    elsif block_given?
      # capture the output of a string-like output and return it as a string.
      @view_context.capture(&block)
    elsif rendering.any?
        @view_context.render(**rendering, formats: :html)
    else
      @view_context.render(partial: target, formats: :html)
    end
  end
end
