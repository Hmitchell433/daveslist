defmodule Daveslist.ListingsTest do
  use Daveslist.DataCase

  alias Daveslist.Listings

  describe "listings" do
    alias Daveslist.Context.Listings
    alias Daveslist.Schema.Listing
    import Daveslist.ListingsFixtures

    @invalid_attrs %{content: nil, is_hide: nil, is_private: nil, title: nil}

    test "list_listings/0 returns all listings" do
      listing = listing_fixture()
      assert Listings.list_listings() == [listing]
    end

    test "get_listing!/1 returns the listing with given id" do
      listing = listing_fixture()
      assert Listings.get_listing!(listing.id) == listing
    end

    test "create_listing/1 with valid data creates a listing" do
      valid_attrs = %{content: "some content", is_hide: true, is_private: true, title: "some title", images: ""}

      assert {:ok, %Listing{} = listing} = Listings.create_listing(valid_attrs)
      assert listing.content == "some content"
      assert listing.is_hide == true
      assert listing.is_private == true
      assert listing.title == "some title"
    end

    test "create_listing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Listings.create_listing(@invalid_attrs)
    end

    test "update_listing/2 with valid data updates the listing" do
      listing = listing_fixture()
      update_attrs = %{content: "some updated content", is_hide: false, is_private: false, title: "some updated title"}

      assert {:ok, %Listing{} = listing} = Listings.update_listing(listing, update_attrs)
      assert listing.content == "some updated content"
      assert listing.is_hide == false
      assert listing.is_private == false
      assert listing.title == "some updated title"
    end

    test "update_listing/2 with invalid data returns error changeset" do
      listing = listing_fixture()
      assert {:error, %Ecto.Changeset{}} = Listings.update_listing(listing, @invalid_attrs)
      assert listing == Listings.get_listing!(listing.id)
    end

    test "delete_listing/1 deletes the listing" do
      listing = listing_fixture()
      assert {:ok, %Listing{}} = Listings.delete_listing(listing)
      assert_raise Ecto.NoResultsError, fn -> Listings.get_listing!(listing.id) end
    end

    test "change_listing/1 returns a listing changeset" do
      listing = listing_fixture()
      assert %Ecto.Changeset{} = Listings.change_listing(listing)
    end
  end
end
