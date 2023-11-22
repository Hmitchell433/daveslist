defmodule Daveslist.UserManagerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Daveslist.UserManager` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test@gmail.com",
        password: "some password",
        username: "some username",
      })
      |> Daveslist.Context.UserManager.create_user()

    user
  end
end
