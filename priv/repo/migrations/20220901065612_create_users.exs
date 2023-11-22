defmodule Daveslist.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :email, :string
      add :user_type, :string, default: "anonymous", null: false

      timestamps()
    end
    create unique_index(:users, [:email])
  end
end