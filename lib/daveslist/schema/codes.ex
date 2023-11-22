defmodule Daveslist.Schema.Codes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "codes" do
    field :user_id, :id
    field :code_hash, :string
    field :valid_until, :utc_datetime
    timestamps()
  end

  @optional ~w[]a
  @required ~w[user_id code_hash valid_until]a

  @doc false
  def changeset(code, attrs) do
    code
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end

end
