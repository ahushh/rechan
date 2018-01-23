defmodule RechanWeb.Api.PostController do
  use RechanWeb, :controller

  alias Rechan.Board
  alias Rechan.Board.Post

  action_fallback RechanWeb.FallbackController

  def index(conn, _params) do
    posts = Board.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Board.create_post(post_params) do
      conn
      |> put_status(:created)
      |> render("show.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Board.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Board.get_post!(id)

    with {:ok, %Post{} = post} <- Board.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Board.get_post!(id)
    with {:ok, %Post{}} <- Board.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
