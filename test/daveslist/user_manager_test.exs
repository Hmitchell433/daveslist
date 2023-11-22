defmodule Daveslist.UserManagerTest do
  use Daveslist.DataCase

  alias Daveslist.Context.UserManager
  alias DaveslistWeb.UserController

  describe "users" do
    alias Daveslist.Schema.User

    import Daveslist.UserManagerFixtures

    @invalid_attrs %{email: nil, password: nil, username: nil}

    test "login without signup" do
      {:error, _} = UserManager.authenticate_user("test@gmail.com", "secret")
    end

    test "signup" do
      params = %{
        username: "test",
        email: "test@gmail.com",
        password: "secret"
      }
      {:ok, user} = UserManager.create_user(params)
      #Login after signup
      {:ok, user} = UserManager.authenticate_user(user.email, "secret")
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "test@gmail.com", password: "some password", username: "some username"}

      assert {:ok, user} = UserManager.create_user(valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserManager.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "test1@gmail.com", password: "some password", username: "some username"}

      assert {:ok, %User{} = user} = UserManager.update_user(user, update_attrs)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserManager.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserManager.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserManager.change_user(user)
    end
  end
end
