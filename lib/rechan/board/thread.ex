defmodule Rechan.Board.Thread do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rechan.Board.Thread


  schema "threads" do
    has_many :posts, Rechan.Board.Post
    timestamps()
  end

  @doc false
  def changeset(%Thread{} = thread, attrs) do
    thread
    |> cast(attrs, [])
    |> validate_required([])
  end
end
