defmodule DaveslistWeb.CategoryView do
  use DaveslistWeb, :view
  alias __MODULE__


  def render("success.json", %{status: status, category: category}) do
    %{
      status: status,
      msg: "Category created successfully",
      name: category.name,
      is_private: category.is_private
    }
  end

  def render("moderator_error.json", %{error: reason}) do
    %{
      status: reason,
      msg: "Your are not a Moderator"
     }
  end

  def render("error.json", %{error: reason}) do
    %{
      status: reason,
      msg: "Something went wrong"
     }
  end



  def render("default_error.json", %{error: reason}) do
    %{
      status: reason
     }
  end

  def render("delete_success.json", %{status: status}) do
    %{
      status: status,
      msg: "Category moved to trash"
    }
  end

  def render("delete_already_success.json", %{status: status}) do
    %{
      status: status,
      msg: "Category already moved to trash"
    }
  end

end
