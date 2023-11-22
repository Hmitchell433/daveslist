defmodule Daveslist.Repo.Migrations.AddCodesTable do
  use Ecto.Migration

  def change do
    create table(:codes) do
      add :user_id, :id
      add :code_hash, :string
      add :valid_until, :utc_datetime

      timestamps()
    end
  end
end
