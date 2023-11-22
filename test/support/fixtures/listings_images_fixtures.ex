defmodule Daveslist.Listings_imagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Daveslist.Listings_images` context.
  """

  @doc """
  Generate a listing_image.
  """
  def listing_image_fixture(attrs \\ %{}) do
    {:ok, listing_image} =
      attrs
      |> Enum.into(%{
        image: "some image"
      })
      |> Daveslist.Listings_images.create_listing_image()

    listing_image
  end
end
