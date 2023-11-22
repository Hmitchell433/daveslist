defmodule DaveslistWeb.ListingView do
  use DaveslistWeb, :view
  alias __MODULE__

  def render("listings.json", %{listings: listings}) do
      render_many(listings, ListingView, "listing.json")
  end

  def render("listing.json", %{listing: listing}) do
    %{
      title: listing.title,
      content: listing.content,
      is_private: listing.is_private
    }
  end

  def render("success.json", %{success: success}) do
    %{status: success}
  end

  def render("error.json", %{error: reason}) do
    %{status: reason,
       msg: "Somthing went wrong"
     }
  end

  def render("list_error.json", %{error: reason}) do
    %{
      status: reason,
      msg: "No Listing found"
     }
  end

  def render("registered_error.json", %{error: reason}) do
    %{
      status: reason,
      msg: "Your are not Registered"
     }
  end

  def render("category_error.json", %{error: reason}) do
    %{
      status: reason,
      msg: "category not Exist"
     }
  end

  def render("listing_error.json", %{error: reason}) do
    %{
      status: reason,
      msg: "listing cannot  create try again"
     }
  end
end
