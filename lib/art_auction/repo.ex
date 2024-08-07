defmodule ArtAuction.Repo do
  use Ecto.Repo,
    otp_app: :art_auction,
    adapter: Ecto.Adapters.Postgres
end
