defmodule Rechan.Board.Thread do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rechan.Board.Thread


  schema "threads" do
    has_many :posts, Rechan.Board.Post
    field :bumped, :naive_datetime
    timestamps()
  end

  @doc false
  def changeset(%Thread{} = thread, attrs) do
    thread
    |> cast(attrs, [:bumped])
    |> validate_required([])
  end
end
