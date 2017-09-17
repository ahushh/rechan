defmodule RechanWeb.PageController do
  use RechanWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
