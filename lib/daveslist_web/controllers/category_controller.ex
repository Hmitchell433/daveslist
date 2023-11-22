defmodule DaveslistWeb.CategoryController do
  use DaveslistWeb, :controller
  use PhoenixSwagger

  alias Daveslist.{UserManager.Guardian, Context.Categories}


  swagger_path :create do
    post("/api/category")
    summary("Create Category")
    description("Create Category")
    produces("application/json")
    security([%{Bearer: []}])

    parameters do
      body(:body, Schema.ref(:category), "Params", required: true)
    end

    response(200, "Ok", Schema.ref(:response))
  end
  def create(conn, %{"category" => user_params} = params) do

    case Guardian.Plug.current_resource(conn) do
     %{user_type: "moderator"}  = user ->
                  case Categories.create_category(user_params) do
                    {:ok, category} ->
                      render(conn, "success.json", %{status: :ok, category: category})
                    {:error, reason} ->
                      errors = traverse_errors(conn, reason)
                      render(conn, "default_error.json", error: errors)
                  end
      %{user_type: "admin"}  = user ->
                    case Categories.create_category(user_params) do
                      {:ok, category} ->
                        render(conn, "success.json", %{status: :ok, category: category})
                      {:error, reason} ->
                        errors = traverse_errors(conn, reason)
                        render(conn, "default_error.json", error: errors)
                    end
      _ ->
            render(conn, "moderator_error.json", error: :error)

      end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/category/:id/delete")
    summary("Delete Category")
    description("Delete a Category")
    produces("application/json")
    security([%{Bearer: []}])

    parameters do
        id(:path, :string, "category ID", required: true)
    end

    response(200, "Ok", Schema.ref(:response_delete))
  end

  def delete(conn, %{"id" => id}) do
    case Guardian.Plug.current_resource(conn) do
      %{user_type: "moderator"}  = user ->
                   case Categories.get_category!(id) do
                     %{is_trash: false}  = category ->
                       Categories.update_category(category, %{is_trash: true})
                       render(conn, "delete_success.json", status: :ok)
                     %{is_trash: true} ->
                        render(conn, "delete_already_success.json", status: :ok)
                     _ ->
                       render(conn, "error.json", error: :error)
                   end
      %{user_type: "admin"} = user ->
                    case Categories.get_category!(id) do
                      %{is_trash: false}  = category ->
                        Categories.update_category(category, %{is_trash: true})
                        render(conn, "delete_success.json", status: :ok)
                      %{is_trash: true} ->
                         render(conn, "delete_already_success.json", status: :ok)
                      _ ->
                        render(conn, "error.json", error: :error)
                    end
       _ ->
             render(conn, "moderator_error.json", error: :error)

       end
  end

  defp traverse_errors(conn, reason) do
    Ecto.Changeset.traverse_errors(reason, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
end



def swagger_definitions do
  %{

    category:
    swagger_schema do
      title("Create Category")
      description("Create a new category")
      properties do
        name(:string, "Jaguar")
        is_private(:boolean, false)
      end
      example(%{
         category: %{
            name: "Jaguar",
            is_private: false
          }
      })
    end,
    response:
    swagger_schema do
      title("CategoryResponse")
      description("CategoryResponse")
      example(%{
        status: :ok,
        msg: "Category created successfully",
        name: "Jaguar",
        is_private: false
      })
    end,
    delete:
    swagger_schema do
      title("Delete Category")
      description("Delete a category")
      properties do
        id(:integer, 1)
      end
      example(%{
               id: 1
      })
    end,
    response_delete:
    swagger_schema do
      title("DeleteCategoryResponse")
      description("DeleteCategoryResponse")
      example(%{
        status: :ok,
        msg: "Category moved to trash"
      })
    end

  }
end



end
