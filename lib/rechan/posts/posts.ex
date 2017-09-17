defmodule Rechan.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Rechan.Repo

  alias Rechan.Posts.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    query = from p in Post, where: is_nil(p.parent_id)
    query
    |> Repo.all()
    |> Enum.map(fn(post) -> load_children(post) end)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Post
    |> Repo.get!(id)
    |> load_children
  end

  @doc """
  Gets a single post.

  """
  def get_post(id) do
    case Repo.get(Post, id) do
      nil -> {:error, :not_found}
      %Post{} = post -> {:ok, load_children post}
    end
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    post = %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    case post do
      {:ok, post} -> {:ok, post |> Repo.preload(:children)}
      default -> default
    end

  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  def load_children(model), do: load_children(model, 10)
  def load_children(_, limit) when limit < 0, do: raise "Recursion limit reached"
  def load_children(%Post{children: %Ecto.Association.NotLoaded{}} = model, limit) do
    model = model |> Repo.preload(:children)
    Map.update!(model, :children, fn(list) ->
      Enum.map(list, &load_children(&1, limit - 1))
    end)
  end

end
