defmodule Daveslist.Context.Chat do
  import Ecto.Query, warn: false
  alias Daveslist.Repo

  alias Daveslist.Schema.Chat

  def create(attrs \\ %{}) do
    %Chat{}
    |> Chat.changeset(attrs)
    |> Repo.insert()
  end

end