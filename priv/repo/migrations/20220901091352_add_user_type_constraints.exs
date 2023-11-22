defmodule Daveslist.Repo.Migrations.AddUserTypeConstraints do
  use Ecto.Migration

  def change do
    create(
      constraint(
        :users,
        :user_type,
        check: "user_type in ('anonymous', 'registered', 'admin', 'moderator')"
      )
    )
  end
end
