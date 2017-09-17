defmodule Rechan.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rechan.Posts.Post


  schema "posts" do
    field :body, :string
    has_many :children, Post, foreign_key: :parent_id
    belongs_to :parent, Post

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:body, :parent_id])
    |> validate_required([:body])
  end

end
