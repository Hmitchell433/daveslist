defmodule Daveslist.Schema.ListingImage do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema

  alias Daveslist.Schema

  schema "listings_images" do
    field :image, :string
    belongs_to :listing, Schema.Listing
    timestamps()
  end

  @doc false
  def changeset(listing_image, attrs) do
    listing_image
    |> cast(attrs, [:image, :listing_id])
    |> validate_required([:image])
  end

  # def validate_image(listing_image, attrs) do
  #   cast_attachments(listing_image, attrs, [:image])
  # end

end
