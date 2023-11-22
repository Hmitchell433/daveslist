defmodule Daveslist.Repo.Migrations.CreateListingsImages do
  use Ecto.Migration

  def change do
    create table(:listings_images) do
      add :image, :string
      add :listing_id, references(:listings, on_delete: :delete_all, type: :id)
      timestamps()
    end
  end
end
