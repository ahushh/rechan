defmodule RechanWeb.PostController do
  use RechanWeb, :controller

  alias Rechan.Posts
  alias Rechan.Posts.Post

  action_fallback RechanWeb.FallbackController

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Posts.create_post(post_params) do
      conn
      |> put_status(:created)
#      |> put_resp_header("location", post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

#  def show(conn, %{"id" => id}) do
#    post = Posts.get_post!(id)
#    render(conn, "show.json", post: post)
#  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Post{} = post} <- Posts.get_post(id) do
      render(conn, "show.json", post: post)
    end
  end


  def update(conn, %{"id" => id, "post" => post_params}) do
    with {:ok, %Post{} = post} <- Posts.get_post(id) do
      with {:ok, %Post{} = post} <- Posts.update_post(post, post_params) do
        render(conn, "show.json", post: post)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    with {:ok, %Post{}} <- Posts.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
