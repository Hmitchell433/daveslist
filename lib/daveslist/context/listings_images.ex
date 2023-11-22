defmodule Daveslist.Context.ListingsImages do
  @moduledoc """
  The Listings_images context.
  """

  import Ecto.Query, warn: false
  alias Daveslist.Repo

  alias Daveslist.Schema.ListingImage

  @doc """
  Returns the list of listings_images.

  ## Examples

      iex> list_listings_images()
      [%Listing_image{}, ...]

  """
  def list_listings_images do
    Repo.all(ListingImage)
  end

  @doc """
  Gets a single listing_image.

  Raises `Ecto.NoResultsError` if the Listing image does not exist.

  ## Examples

      iex> get_listing_image!(123)
      %Listing_image{}

      iex> get_listing_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_listing_image!(id), do: Repo.get!(ListingImage, id)

  @doc """
  Creates a listing_image.

  ## Examples

      iex> create_listing_image(%{field: value})
      {:ok, %Listing_image{}}

      iex> create_listing_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_listing_image(attrs \\ %{}) do
    %ListingImage{}
    |> ListingImage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a listing_image.

  ## Examples

      iex> update_listing_image(listing_image, %{field: new_value})
      {:ok, %Listing_image{}}

      iex> update_listing_image(listing_image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_listing_image(%ListingImage{} = listing_image, attrs) do
    listing_image
    |> ListingImage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a listing_image.

  ## Examples

      iex> delete_listing_image(listing_image)
      {:ok, %Listing_image{}}

      iex> delete_listing_image(listing_image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_listing_image(%ListingImage{} = listing_image) do
    Repo.delete(listing_image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking listing_image changes.

  ## Examples

      iex> change_listing_image(listing_image)
      %Ecto.Changeset{data: %Listing_image{}}

  """
  def change_listing_image(%ListingImage{} = listing_image, attrs \\ %{}) do
    ListingImage.changeset(listing_image, attrs)
  end
end
