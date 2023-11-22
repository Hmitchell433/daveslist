defmodule DaveslistWeb.ListingController do
  use DaveslistWeb, :controller
  use PhoenixSwagger

  alias Daveslist.Context.{Listings, Categories, ListingsImages}
  alias Daveslist.Schema.ListingImage



    swagger_path :public_listings do
      get("/api/public-listings")
      summary("Public Listings")
      description("Public listings are listed")
      produces("application/json")

      response(200, "Ok", Schema.ref(:response_public_listing))
    end

   def public_listings(conn, _params) do
    case Listings.public_listings do
      [] ->
        render(conn, "list_error.json", error: :error)
      listings ->
        render(conn, "listings.json", listings: listings)
    end
  end

  swagger_path :all_listings do
    get("/api/listings")
    summary("All Listings")
    description("All public and private listing are shown here")
    produces("application/json")
    security([%{Bearer: []}])

    response(200, "Ok", Schema.ref(:response_public_listing))
  end

  def all_listings(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      %{user_type: "registered"}  = user ->
                   case Listings.list_listings do
                    [] ->
                      render(conn, "list_error.json", error: :error)
                    listings ->
                      render(conn, "listings.json", listings: listings)
                  end
      %{user_type: "admin"} = user ->
                    case Listings.list_listings do
                      [] ->
                        render(conn, "list_error.json", error: :error)
                      listings ->
                        render(conn, "listings.json", listings: listings)
                    end
       _ ->
             render(conn, "registered_error.json", error: :error)

       end
  end


  swagger_path :create do
    post("/api/listings")
    summary("Create listings")
    description("Create listings")
    produces("application/json")
    security([%{Bearer: []}])

    parameters do
      body(:body, Schema.ref(:listing), "Params", required: true)
    end

    response(200, "Ok", Schema.ref(:response_public_listing))
  end

  def create(conn,  %{"title" => title, "content" => content, "images" => images, "category" => category}= params) do
    case Guardian.Plug.current_resource(conn) do
      %{user_type: "registered"}  = user ->
                case Categories.get_category_by_name(params["category"]) do
                  nil -> render(conn, "category_error.json", error: "category not Exist")
                  category ->
                      params = %{title: params["title"], content: params["content"], is_private: params["is_private"], image: params["images"]}
                      case Listings.create_listing(params) do
                       {:error, _error} ->
                         render(conn, "listing_error.json", error: :error)
                       {:ok, listing} ->
                          upload_image_size(params, listing.id)
                          render(conn, "listing.json", listing: listing)
                     end
                 end

       _ ->
             render(conn, "registered_error.json", error: :error)

       end
  end


  def create(conn, params) do
    render(conn, "error.json", error: :error)
  end

  swagger_path :edit do
    get("/api/listings/:id/edit")
    summary("Edit Listing")
    description("Edit Listing")
    produces("application/json")
    security([%{Bearer: []}])

    parameters do
        id(:path, :string, "Listing ID", required: true)
    end

    response(200, "Ok", Schema.ref(:response_listing))
  end

  def edit(conn, %{"id" => id} = params) do
    case Guardian.Plug.current_resource(conn) do
      %{user_type: "admin"}  = user ->
                   case Listings.get_listing!(id) do
                     listing ->
                       Listings.update_listing(listing, params)
                       render(conn, "success.json", success: :ok)
                     _ ->
                       render(conn, "error.json", error: :error)
                   end

      %{user_type: "registered"}  = user ->
          case Listings.get_listing!(id) do
             listing ->
              Listings.update_listing(listing, params)
              render(conn, "success.json", success: :ok)
            _ ->
              render(conn, "error.json", error: :error)
          end
       _ -> render(conn, "error.json", error: :error)
     end
end

swagger_path :delete do
  PhoenixSwagger.Path.delete("/api/listings/:id/delete")
  summary("Delete Listing")
  description("Delete Listing")
  produces("application/json")
  security([%{Bearer: []}])

  parameters do
      id(:path, :string, "Listing ID", required: true)
  end

  response(200, "Ok", Schema.ref(:response_delete))
end

  def delete(conn, %{"id" => id}) do
    case Guardian.Plug.current_resource(conn) do
      %{user_type: "moderator"}  = user ->
                   case Listings.get_listing!(id) do
                     %{is_hide: false}  = listing ->
                       Listings.update_listing(listing, %{is_hide: true})
                       render(conn, "success.json", success: :ok)
                     %{is_hide: true} ->
                        render(conn, "success.json", success: :ok)
                     _ ->
                       render(conn, "error.json", error: :error)
                   end
      %{user_type: "admin"} = user ->
                  case Listings.get_listing!(id) do
                     listing ->
                      Listings.delete_listing(listing)
                      render(conn, "success.json", success: :ok)
                    _ ->
                      render(conn, "error.json", error: :error)
                  end
      %{user_type: "registered"} = user ->
                    case Listings.get_listing!(id) do
                       listing ->
                        Listings.delete_listing(listing)
                        render(conn, "success.json", success: :ok)
                      _ ->
                        render(conn, "error.json", error: :error)
                    end
       _ ->
             render(conn, "error.json", error: :error)

       end
  end


  defp upload_image_size(params, id) do
    if length(params.image) <= 10 do
       Enum.map(params.image, fn image ->
        params = %{image: image, listing_id: id}
        case ListingsImages.create_listing_image(params) do
          {:error, _error} -> :error
          {:ok, _listing} -> :ok
      end
    end)
    else
      :error
    end
  end



  # defp upload_image(conn, params, listing) do
  #   list = []
  #    Enum.map(params[:image],fn image ->
  #     case ListingImage.validate_image(params, %{image: image}) |> IO.inspect(label: "validate_image") do
  #       {:ok, _} -> list ++ [image]
  #       {:error, _} -> render(conn, "error.json", error: "Images with these extension are no acceptable")
  #     end
  #   end)
  # end

  def swagger_definitions do
    %{
      listing:
      swagger_schema do
        title("Create listing")
        description("Create a new listing")
        properties do
          title(:string, "Jaguar", required: true)
          is_private(:boolean, false)
          category(:string,"Alto", required: true)
          images(:array, ["alto.png","range_rover.jpg"])
        end
        example(%{

          title: "Buy the car",
          content: "Red Color",
          category: "Alto",
          is_private: true,
          images: ["alto.png","range_rover.jpg"]

        })
      end,
      response_public_listing:
      swagger_schema do
        title("Public Listing Response")
        description("Public Listing Response")
        example(
        [
          %{
            title: "Daves List",
            content: "Here we go",
            is_private: false
          },
          %{
            title: "Daves",
            content: "Here We GOo",
            is_private: false
          }
         ])
      end,
      response_listing:
      swagger_schema do
        title("Listing Response")
        description("Listing Response")
        example(
          %{
            title: "Daves List",
            content: "Here we go",
            is_private: false
          })
      end,
      response_delete:
      swagger_schema do
        title("Delete Listing Response")
        description("Delete Listing Response")
        example(
          %{
            status: "ok"
          })
      end
    }
  end


end
