defmodule Rechan.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :string
      add :parent_id, references(:posts, on_delete: :nothing)

      timestamps()
    end

  end
end
