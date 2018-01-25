defmodule Rechan.Repo.Migrations.AddBumpedFieldToThreadsTable do
  use Ecto.Migration

  def change do
    alter table(:threads) do
      add :bumped, :naive_datetime, [null: false, default: fragment("(now() at time zone 'utc')")]
    end
  end
end
