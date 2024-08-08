defmodule ArtAuction.Auction.Lot do
  use Ecto.Schema

  alias ArtAuction.Auction.Bid
  alias ArtAuction.Auction.Exhibition

  schema "auction_lots" do
    field :number, :integer
    field :name, :string
    field :description, :string
    # TODO: bind several donors
    # TODO: photos

    field :status, Ecto.Enum, values: [standby: 1, available: 2, commiting: 3, finished: 4]
    field :starting_bid, :decimal
    field :increment, :decimal

    belongs_to Exhibition, :exhibition
    has_many Bid, :bids
    timestamps(type: :utc_datetime)
  end
end
