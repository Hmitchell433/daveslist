defmodule DaveslistWeb.PageController do
  use DaveslistWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
