defmodule Daveslist.Context.Replies do
  import Ecto.Query, warn: false
  alias Daveslist.Repo

  alias Daveslist.Schema.Replies

  def create(attrs \\ %{}) do
    %Replies{}
    |> Replies.changeset(attrs)
    |> Repo.insert()
  end

end