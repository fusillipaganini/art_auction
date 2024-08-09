defmodule ArtAuction.Auction.Bid do
  use Ecto.Schema

  alias ArtAuction.Auction.Lot
  alias ArtAuction.User.Account

  @type id :: pos_integer()
  @type t :: %__MODULE__{
          id: id,
          amount: Decimal.t(),
          anonymous: boolean(),
          status: :valid | :rejected | :winner | :unfulfiled | :expired,
          account_id: Account.id(),
          account: Ecto.Schema.belongs_to(Account.t()),
          lot_id: Lot.id(),
          lot: Ecto.Schema.belongs_to(Lot.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "auction_bids" do
    field :amount, :decimal
    field :anonymous, :boolean

    field :status, Ecto.Enum,
      values: [valid: 1, rejected: 2, winner: 3, unfulfiled: 4, expired: 5]

    belongs_to :account, Account
    belongs_to :lot, Lot

    timestamps(type: :utc_datetime)
  end
end
