defmodule Daveslist.CategoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Daveslist.Categories` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        is_private: true,
        is_trash: true,
        name: "some name"
      })
      |> Daveslist.Context.Categories.create_category()

    category
  end
end
