defmodule LiveScream.Auction.Lot do
  use Ecto.Schema

  alias LiveScream.Auction.Bid
  alias LiveScream.Auction.Exhibition

  @type id :: pos_integer()
  @type t :: %__MODULE__{
          id: id,
          number: non_neg_integer(),
          name: String.t(),
          description: String.t(),
          status: :standby | :active | :commiting | :finished | :cancelled,
          starting_bid: Decimal.t(),
          increment: Decimal.t(),
          exhibition_id: Exhibition.id(),
          exhibition: Ecto.Schema.belongs_to(Exhibition.t()),
          bids: Ecto.Schema.has_many(Bid.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "auction_lots" do
    # The lot number is used both as a way to refer to a given lot and also as a parameter to order the lots
    field :number, :integer
    field :name, :string
    field :description, :string
    # TODO: bind several donors
    # TODO: photos

    # Standby - When a lot is available and will eventually be put for bids on an exhibition
    # Active - A temporary status for when a lot is being bid on an active exhibition
    # Commiting - The bids have just finished and now the auction manager is waiting for the winning bidder to pay
    # Finished - When the lot was won by someone and that someone has properly paid
    # Cancelled - When for some reason the lot is cancelled (eg: no bids)
    field :status, Ecto.Enum,
      values: [standby: 1, active: 2, commiting: 3, finished: 4, cancelled: 5],
      default: :standby

    field :starting_bid, :decimal, default: Decimal.new(0)
    field :increment, :decimal, default: Decimal.new(1)

    belongs_to :exhibition, Exhibition
    has_many :bids, Bid

    timestamps(type: :utc_datetime)
  end
end
