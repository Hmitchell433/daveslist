defmodule Daveslist.Repo.Migrations.CreateChat do
  use Ecto.Migration

  def change do
    create table(:chat) do
    add :from, :id
    add :to, :id
    add :message, :string

    timestamps()
    end
  end
end
