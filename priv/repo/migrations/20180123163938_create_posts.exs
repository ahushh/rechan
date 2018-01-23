defmodule Rechan.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :text
      add :thread_id, references(:threads), null: true
      timestamps()
    end
    create index(:posts, [:thread_id])
  end
end
