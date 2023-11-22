defmodule Daveslist.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :is_private, :boolean, default: false
    field :is_trash, :boolean, default: false
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :is_private, :is_trash])
    |> unique_constraint(:name)
    |> validate_required([:name, :is_private, :is_trash])
  end
end
