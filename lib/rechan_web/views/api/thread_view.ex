defmodule RechanWeb.Api.ThreadView do
  use RechanWeb, :view
  alias RechanWeb.Api.ThreadView

  def render("index.json", %{threads: threads}) do
    %{data: render_many(threads, ThreadView, "thread.json")}
  end

  def render("show.json", %{thread: thread}) do
    %{data: render_one(thread, ThreadView, "thread.json")}
  end

  def render("thread.json", %{thread: thread}) do
    %{id: thread.id, posts: render_many(thread.posts, RechanWeb.Api.PostView, "post.json")}
  end
end
