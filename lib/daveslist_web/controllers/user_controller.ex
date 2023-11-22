defmodule DaveslistWeb.UserController do
  use DaveslistWeb, :controller
  use PhoenixSwagger

  alias Daveslist.{Context.UserManager, Schema.User, UserManager.Guardian}
  alias Daveslist.Context
  alias Daveslist.Mailer.Email
  alias Daveslist.Mailer
  alias Daveslist.Schema.Codes

  def index(conn, _) do
    changeset = UserManager.change_user(%User{})
    render(conn, "login.html", changeset: changeset, action: Routes.user_path(conn, :login))
  end

  swagger_path :create do
    post("/api/signup")
    summary("Sign_Up")
    description("Sign_Up")
    produces("application/json")
    parameters do
      body(:body, Schema.ref(:signup), "Params", required: true)
    end

    response(200, "Ok", Schema.ref(:response))
  end

  def create(conn, params) do
    user = UserManager.create_user(params)
    case user do
      {:ok, user} ->
        # background task to send the email to verify the account
        Task.async(fn ->
          # insert the verification code for that user
          {:ok, code} = Context.Codes.insert_random_code(user.id)
          # send verification email
          Email.welcome_text_email(user.email, code.code_hash)
          |> Mailer.deliver_now()
        end)
        render(conn, "success.json", status: :ok)
      {:error, reason} ->
        errors = traverse_errors(conn, reason)
        render(conn, "error.json", error: errors)
    end
  end

  swagger_path :login do
    post("/api/login")
    summary("Login")
    description("Login")
    produces("application/json")
    parameters do
      body(:body, Schema.ref(:login), "Params", required: true)
    end

    response(200, "Ok", Schema.ref(:response_login))
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    UserManager.authenticate_user(email, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    render(conn, "login.json", token: token)
  end

  defp login_reply({:error, reason}, conn) do
    render(conn, "error.json", error: reason)
  end

  defp traverse_errors(conn, reason) do
      Ecto.Changeset.traverse_errors(reason, fn {msg, opts} ->
        Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
          opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
        end)
      end)
  end

  def verify(conn, %{"w" => code}) do
    with %Ecto.Query{} = query <- Context.Codes.verify_code_value(code),
         %Codes{user_id: user_id, code_hash: code_hash} = code_res <- Daveslist.Repo.one(query) do
      # Activate email
      case Context.UserManager.activate_credential(user_id) do
        {:ok, params} ->
          # delete the verification code for this user
          Context.Codes.delete_code(user_id)
          redirect(conn, to: "/login")

        {:error, error} ->
          conn
          |> redirect(to: "/signup")
      end
    end
  else
    _ ->
      conn
      |> redirect(to: "/signup")
  end





  def swagger_definitions do
    %{

      signup:
      swagger_schema do
        title("Sign_Up")
        description("Sign_Up")
        properties do
          password(:string, "secret")
          username(:string, "David")
          email(:string, "xyz@gmail.com")
        end
        example(%{
          password: "secret",
          username: "David",
          email: "xyz@gmail.com"
        })
      end,
      response:
      swagger_schema do
        title("SignUpResponse")
        description("SignUpResponse")
        example(%{
          status: "ok"
        })
      end,
      login:
      swagger_schema do
        title("Login")
        description("Login")
        properties do
          password(:string, "secret")
          email(:string, "xyz@gmail.com")
        end
        example(%{
          user: %{
                 password: "secret",
                 email: "xyz@gmail.com"
                }
        })
      end,
      response_login:
      swagger_schema do
        title("LoginResponse")
        description("LoginResponse")
        example(%{
          status: "successfully login",
          token: "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJkYXZlc2xpc3QiLCJleHAiOjE2NjQ1MzAyMjYsImlhdCI6MTY2MjExMTAyNiwiaXNzIjoiZG
                  F2ZXNsaXN0IiwianRpIjoiMDJiZmJjZDctYWM2Zi00YjliLWExMTctZmM4MzcyY2M0MDg0IiwibmJmIjoxNjYyMTExMDI1LCJzdWIiOiIyIiwidHlwIjoiY
                  WNjZXNzIn0.lwo0cavquHZUKHseMiQLncHkYPShdtQUwhxVWkjaMqesjADVmADyMUXoVmTxLc95XGk_UKIhb8Ipddmbg2XrDQ"
        })
      end

    }
  end






end
