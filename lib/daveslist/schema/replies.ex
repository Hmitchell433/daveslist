defmodule Daveslist.Schema.Replies do
  use Ecto.Schema
  import Ecto.Changeset

  alias Daveslist.Schema

  schema "replies" do
    field :comment, :string
    field :user_id, :id
    belongs_to :list, Schema.Listing
    timestamps()
  end

  @doc false
  def changeset(replies, attrs) do
    replies
    |> cast(attrs, [:comment, :user_id, :list_id])
    |> validate_required([:comment, :user_id])
    |> validate_length(:comment, max: 250)
    |> cast_assoc(:list)
  end

end
