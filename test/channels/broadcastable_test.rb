require 'test_helper'

class TurboClone::BroadcastableTest < ActionCable::Channel::TestCase
  include TurboClone::ActionHelper
  # perform_enqueued_jobs
  include ActiveJob::TestHelper

  test "#broadcast_append_to" do
    article = Article.create! content: "Something"

    assert_broadcast_on "stream_name", turbo_stream_action_tag(:append, target: "articles", template: render(article)) do
      article.broadcast_append_to "stream_name"
    end
  end

  test "#broadcast_append_later_to" do
    article = Article.create! content: "Something"

    assert_broadcast_on "stream_name", turbo_stream_action_tag(:append, target: "articles", template: render(article)) do
      perform_enqueued_jobs do
        article.broadcast_append_later_to "stream_name"
      end
    end
  end

  test "#broadcast_prepend_to" do
    article = Article.create! content: "Something"

    assert_broadcast_on "stream_name", turbo_stream_action_tag(:prepend, target: "board_articles", template: render(article)) do
      article.broadcast_prepend_to "stream_name", target: "board_articles"
    end
  end

  test "#broadcast_prepend_later_to" do
    article = Article.create! content: "Something"

    assert_broadcast_on "stream_name", turbo_stream_action_tag(:prepend, target: "board_articles", template: render(article)) do
      perform_enqueued_jobs do
        article.broadcast_prepend_later_to "stream_name", target: "board_articles"
      end
    end
  end

  test "#broadcast_replace_to" do
    article = Article.create! content: "Something"

    assert_broadcast_on "stream_name", turbo_stream_action_tag(:replace, target: article, template: render(article)) do
      article.broadcast_replace_to "stream_name"
    end
  end

  test "#broadcast_replace_later_to" do
    article = Article.create! content: "Something"

    assert_broadcast_on "stream_name", turbo_stream_action_tag(:replace, target: article, template: render(article)) do
      perform_enqueued_jobs do
        article.broadcast_replace_later_to "stream_name"
      end
    end
  end

  test "#broadcast_remove_to" do
    article = Article.create! content: "Something"

    assert_broadcast_on "stream_name", turbo_stream_action_tag(:remove, target: article, template: nil) do
      article.broadcast_remove_to "stream_name"
    end
  end
end