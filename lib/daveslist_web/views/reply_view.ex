defmodule DaveslistWeb.ReplyView do
  use DaveslistWeb, :view

  alias __MODULE__
  def render("success.json", %{status: status}) do
    %{
      status: status,
      msg: "Comment has been added"
     }
  end

  def render("error.json", %{status: reason}) do
    %{status: reason}
  end

  def render("old_listing_error.json", %{status: reason}) do
    %{
      status: reason,
      msg: "Listing shouldn't be more than 1 year old"
    }
  end
end
