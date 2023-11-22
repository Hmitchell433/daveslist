defmodule DaveslistWeb.ReplyController do
  use DaveslistWeb, :controller
  use PhoenixSwagger

  alias Daveslist.Context.Replies
  alias Daveslist.Context.Listings
  alias Daveslist.Schema.Listing


  swagger_path :create do
    post("/api/listings/reply")
    summary("Reply to a Listing by listing id")
    description("Reply to a Listing by listing id")
    produces("application/json")
    security([%{Bearer: []}])

    parameters do
        body(:body, Schema.ref(:comment), "Params", required: true)
    end

    response(200, "Ok", Schema.ref(:response_comment))
  end
  def create(conn, %{"id" => id} = params) do
    IO.inspect(id, label: "idddd")
    if post_is_older_than_1_year(id) do
    user = Guardian.Plug.current_resource(conn)
    params = %{
      user_id: user.id,
      list_id: id,
      comment: params["comment"]
    }
    reply = Replies.create(params)
    case reply do
      {:ok, reply} ->
        render(conn, "success.json", status: :ok)
      {:error, reason} ->
        errors =
          Ecto.Changeset.traverse_errors(reason, fn {msg, opts} ->
          Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
            opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
          end)
        end)
        render(conn, "error.json", status: errors)
    end
    else
      render(conn, "old_listing_error.json", status: :error)
    end
  end


  defp post_is_older_than_1_year(list_id) do
    %Listing{inserted_at: created_date} = list = Listings.get_listing!(list_id)
    current_date = DateTime.to_date(DateTime.utc_now())
    created_date = NaiveDateTime.to_date(created_date)
    current_date.year - created_date.year <= 1 && true || false
  end


  def swagger_definitions do
    %{

      response_comment:
      swagger_schema do
        title("Reply to a Listing by listing id")
        description("Reply to a Listing by listing id")
        example(
          %{
            status: "ok",
            msg: "Comment has been added"
          })
      end,
      comment:
      swagger_schema do
        title("Create listing")
        description("Create a new listing")
        properties do
          comment(:string,"Hello", required: true)
        end
        example(%{
          id: 3,
         comment: "Hello"
        })
      end
    }
  end


end
