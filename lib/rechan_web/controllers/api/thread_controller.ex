defmodule RechanWeb.Api.ThreadController do
  use RechanWeb, :controller

  alias Rechan.Board
  alias Rechan.Board.Thread

  action_fallback RechanWeb.FallbackController

  def index(conn, params) do
    %{entries: threads} = Board.list_threads(params)
    render(conn, "index.json", threads: threads)
  end

  def create(conn, %{"thread" => thread_params}) do
    with {:ok, %Thread{} = thread} <- Board.create_thread(thread_params) do
      conn
      |> put_status(:created)
      |> render("show.json", thread: thread)
    end
  end

  def show(conn, %{"id" => id}) do
    thread = Board.get_thread!(id)
    render(conn, "show.json", thread: thread)
  end

  def update(conn, %{"id" => id, "thread" => thread_params}) do
    thread = Board.get_thread!(id)

    with {:ok, %Thread{} = thread} <- Board.update_thread(thread, thread_params) do
      render(conn, "show.json", thread: thread)
    end
  end

  def delete(conn, %{"id" => id}) do
    thread = Board.get_thread!(id)
    with {:ok, %Thread{}} <- Board.delete_thread(thread) do
      send_resp(conn, :no_content, "")
    end
  end
end
