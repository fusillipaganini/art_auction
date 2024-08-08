defmodule ArtAuction.Auction.Bid do
  use Ecto.Schema

  alias ArtAuction.Auction.Lot
  alias ArtAuction.User.Account

  schema "auction_bids" do
    belongs_to Lot, :lot
    belongs_to Account, :account
    field :amount, :decimal

    timestamp(type: :utc_datetime)
  end
end
