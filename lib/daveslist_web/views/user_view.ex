defmodule DaveslistWeb.UserView do
  use DaveslistWeb, :view
  alias __MODULE__

  def render("login.json", %{token: token}) do
    %{
      status: "successfully login",
      token: token
    }
  end

  def render("success.json", %{status: status}) do
    %{
      status: status,
      msg: "An email has been sent to you please register your account."
    }
  end

  def render("error.json", %{error: reason}) do
    %{status: reason}
  end

end
