defmodule Daveslist.Schema.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat" do
    field :from, :id
    field :to, :id
    field :message, :string
    timestamps()
  end

  @optional ~w[]a
  @required ~w[from to message]a

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end

end