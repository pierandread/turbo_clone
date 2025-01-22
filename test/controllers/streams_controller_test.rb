require "test_helper"

class TurboClone::StreamsControllerTest < ActionDispatch::IntegrationTest
  test "create with respond to" do
    post articles_path, params: { article: { content: 'something' }}
    assert_redirected_to articles_path

    post articles_path, params: { article: { content: 'something' }}, as: :turbo_stream
    assert_turbo_stream action: "prepend", target: "articles"
  end

  test "update with respond to" do
    article = Article.create! content: 'something'

    patch article_path(article.id), params: { article: { content: 'asd' }}
    assert_redirected_to articles_path

    patch article_path(article.id), params: { article: { content: 'asd2' }}, as: :turbo_stream
    assert_turbo_stream action: "replace", target: article

  end

  test "destroy with respond to" do
    article = Article.create! content: 'something'

    delete article_path(article.id)
    assert_redirected_to articles_path

    article2 = Article.create! content: 'something 2'

    delete article_path(article2.id), as: :turbo_stream
    assert_turbo_stream action: "remove", target: article2
  end

  test "show all turbo actions" do
    article = Article.create! content: 'content'
    get article_path(article), as: :turbo_stream
    assert_dom_equal <<~HTML, @response.body
      <turbo-stream action="remove" target="#{dom_id(article)}"></turbo-stream>
      <turbo-stream action="update" target="#{dom_id(article)}"><template>#{render(article)}</template></turbo-stream>
      <turbo-stream action="replace" target="#{dom_id(article)}"><template>something else</template></turbo-stream>
      <turbo-stream action="prepend" target="articles"><template>#{render(article)}</template></turbo-stream>
      <turbo-stream action="prepend" target="articles"><template>#{render(article)}</template></turbo-stream>
    HTML
  end
end