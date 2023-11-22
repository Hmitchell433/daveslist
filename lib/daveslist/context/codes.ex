defmodule Daveslist.Context.Codes do
  @moduledoc """
  The Codes context.
  """

  import Ecto.Query, warn: false
  alias Daveslist.Repo
  alias Argon2

  alias Daveslist.Schema.{Codes, User}

  @code_length 64
  # 2 days
  @code_lifetime 60 * 60 * 24 * 2

  def insert_random_code(user_id) do
    code = "#{generate_random_code()}id:#{user_id}"
    attrs =  %{user_id: user_id, code_hash: code, valid_until: code_lifetime()}
    %Codes{}
    |> Codes.changeset(attrs)
    |> Repo.insert()
  end

  def generate_random_code() do
    :crypto.strong_rand_bytes(@code_length) |> Base.url_encode64() |> binary_part(0, @code_length)
  end

  def code_lifetime() do
    DateTime.utc_now()
    |> DateTime.add(@code_lifetime)
  end

  def verify_code_value(value) do
    with [_code, id] <- String.split(value, ":") do
      Ecto.Query.from(c in Codes,
        where: c.user_id == ^id and c.valid_until > ^DateTime.utc_now()
      )
    else
      _ ->
        {:error, :invalid_value}
    end
  end

  def query_code_by_code_value(type, value) do
    with [id, _code] <- String.split(value, ":"),
         {id, ""} <- Integer.parse(id) do
      Ecto.Query.from(c in __MODULE__,
        where: c.id == ^id and c.type == ^type and c.valid_until > ^DateTime.utc_now()
      )
    else
      _ -> {:error, :invalid_value}
    end
  end

  def get_code_by_user_id(user_id) do
    from(c in Codes, where: c.user_id == ^user_id, select: c) |> Repo.one()
  end

  def delete_code(user_id) do
    code = get_code_by_user_id(user_id)
    Repo.delete(code)
  end

end
