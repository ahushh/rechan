defmodule Rechan.Board.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rechan.Board.Post


  schema "posts" do
    field :body, :string
    belongs_to :thread, Rechan.Board.Thread
    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:body, :thread_id])
    |> validate_required([:body])
  end
end
