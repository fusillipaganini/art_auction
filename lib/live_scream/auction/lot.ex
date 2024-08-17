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
          status: :standby | :available | :commiting | :finished,
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

    field :status, Ecto.Enum,
      values: [standby: 1, available: 2, commiting: 3, finished: 4],
      default: :standby

    field :starting_bid, :decimal, default: Decimal.new(0)
    field :increment, :decimal, default: Decimal.new(1)

    belongs_to :exhibition, Exhibition
    has_many :bids, Bid

    timestamps(type: :utc_datetime)
  end
end
