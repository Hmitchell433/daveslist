defmodule Daveslist.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :is_private, :boolean, default: false, null: false
      add :is_trash, :boolean, default: false, null: false

      timestamps()
    end
    create unique_index(:categories, [:name])
  end
end
