class TurboClone::StreamsChannel < ActionCable::Channel::Base
  def subscribed
    # <turbo-cable-stream-source channel="TurboClone::StreamsChannel" signed-stream-name='articles'>
    stream_from params[:signed_stream_name]
  end
end

# % rails c
# Loading development environment (Rails 7.1.5.1)
  # irb(main):001> article = Article.first
    # Article Load (0.1ms)  SELECT "articles".* FROM "articles" ORDER BY "articles"."id" ASC LIMIT ?  [["LIMIT", 1]]
    # =>
    #   #<Article:0x0000000107054f80
    #   ...
  # irb(main):002> article.content = "ActionCable"
    #  => "ActionCable"
  # irb(main):003> template = ApplicationController.render("articles/update", assigns: { article: article })
    # Rendering articles/update.turbo_stream.erb
    # Rendered articles/_article.html.erb (Duration: 0.5ms | Allocations: 391)
    # Rendered articles/update.turbo_stream.erb (Duration: 2.5ms | Allocations: 968)
    # => "<turbo-stream action=\"replace\" target=\"article_1\"><template><turbo-frame id=\"article_1\">\n  <div>\n    Article #1\n    &bull;\n    ActionCable\n    &bull;\n    <a...
  # irb(main):004> ActionCable.server.broadcast "articles", template
    # [ActionCable] Broadcasting to articles: "<turbo-stream action=\"replace\" target=\"article_1\"><template><turbo-frame id=\"article_1\">\n  <div>\n    Article #1\n    &bull;\n    ActionCable\n    &bull;\n    <a href=\"/articles/1/edit\">Edit</a>\n    &bull;\n    <form style=\"display:inline; \" class=\"button_to\" method=\"post\" action...
    # => 1
