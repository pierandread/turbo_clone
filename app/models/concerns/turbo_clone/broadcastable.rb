module TurboClone::Broadcastable
  extend ActiveSupport::Concern

  class_methods do
    def broadcast_target_default
      model_name.plural
    end
  end

  def broadcast_append_to(*streamables, target: broadcast_target_default, **rendering)
    TurboClone::StreamsChannel.broadcast_append_to(*streamables, target: target, **broadcast_rendering_with_default(rendering))
  end

  def broadcast_prepend_to(*streamables, target: broadcast_target_default, **rendering)
    TurboClone::StreamsChannel.broadcast_prepend_to(*streamables, target: target, **broadcast_rendering_with_default(rendering))
  end

  def broadcast_replace_to(*streamables, target: self, **rendering)
    TurboClone::StreamsChannel.broadcast_replace_to(*streamables, target: target, **broadcast_rendering_with_default(rendering))
  end

  def broadcast_remove_to(*streamables, target: self)
    TurboClone::StreamsChannel.broadcast_remove_to(*streamables, target: target)
  end

  def broadcast_append_later_to(*streamables, target: broadcast_target_default, **rendering)
    TurboClone::StreamsChannel.broadcast_append_later_to(*streamables, target: target, **broadcast_rendering_with_default(rendering))
  end

  private

  def broadcast_rendering_with_default(rendering)
    rendering.tap do |r|
      # irb(main):005> Article.model_name.element.to_sym
      # => :article
      # we want to have -> locals: { article: article }
      r[:locals] = (r[:locals] || {}).reverse_merge!(model_name.element.to_sym => self)
      # irb(main):006> Article.first.to_partial_path
      # Article Load (0.4ms)  SELECT "articles".* FROM "articles" ORDER BY "articles"."id" ASC LIMIT ?  [["LIMIT", 1]]
      # => "articles/article"
      r[:partial] = to_partial_path
    end
  end

  def broadcast_target_default
    self.class.broadcast_target_default
  end
end