defmodule Daveslist.Schema.Listing do
  use Ecto.Schema
  import Ecto.Changeset

  alias Daveslist.Schema

  schema "listings" do
    field :content, :string
    field :is_hide, :boolean, default: false
    field :is_private, :boolean, default: false
    field :title, :string
    has_many :listing, Schema.ListingImage
    has_many :replies, Schema.Replies

    timestamps()
  end

  @doc false
  def changeset(listing, attrs) do
    listing
    |> cast(attrs, [:title, :content, :is_private, :is_hide])
    |> validate_length(:content, max: 5000)
    |> validate_required([:title, :content, :is_private, :is_hide])
  end
end
