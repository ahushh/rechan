defmodule RechanWeb.PostView do
  use RechanWeb, :view
  alias RechanWeb.PostView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    IO.inspect post.children
    %{id: post.id,
      body: post.body,
      children: Enum.map(post.children, fn(post) -> render_one(post, PostView, "post.json") end),
      parent_id: post.parent_id,
     }
  end
end
