defmodule Daveslist.Repo do
  use Ecto.Repo,
    otp_app: :daveslist,
    adapter: Ecto.Adapters.Postgres
end
