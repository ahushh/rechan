# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rechan.Repo.insert!(%Rechan.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Seed do
  def make_threads(0, _), do: nil

  def make_threads(n, replies) do
    thread = %Rechan.Board.Thread{} |> Rechan.Repo.insert!
    with %Rechan.Board.Thread{id: id} <- thread do
      Enum.each 1..replies, fn(i) -> %Rechan.Board.Post{body: "test #{i}", thread_id: id} |> Rechan.Repo.insert! end
      make_threads(n - 1, replies)
    end
  end
end

Seed.make_threads(100, 100)