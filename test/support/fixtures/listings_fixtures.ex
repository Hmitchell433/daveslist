defmodule Daveslist.ListingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Daveslist.Listings` context.
  """

  @doc """
  Generate a listing.
  """
  def listing_fixture(attrs \\ %{}) do
    {:ok, listing} =
      attrs
      |> Enum.into(%{
        content: "some content",
        is_hide: true,
        is_private: true,
        title: "some title"
      })
      |> Daveslist.Context.Listings.create_listing()

    listing
  end
end
