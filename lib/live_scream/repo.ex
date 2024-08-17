defmodule LiveScream.Repo do
  use Ecto.Repo,
    otp_app: :live_scream,
    adapter: Ecto.Adapters.Postgres
end
