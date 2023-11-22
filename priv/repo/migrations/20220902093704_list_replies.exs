defmodule Daveslist.Repo.Migrations.Comments do
  use Ecto.Migration

  def change do
    create table(:replies) do
      add :list_id, references(:listings)
      add :comment, :text
      add :user_id, :id
      timestamps()
    end
  end
end
