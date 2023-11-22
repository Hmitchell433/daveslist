defmodule Daveslist.Repo.Migrations.CreateListings do
  use Ecto.Migration

  def change do

    create table(:listings) do

      add :title, :string, default: "Hello"
      add :content, :text, default: "Here we go"
      add :is_private, :boolean, default: false, null: false
      add :is_hide, :boolean, default: false, null: false
      timestamps()
    end
    
  create index(:listings, [:is_private, :is_hide])
  end

end
