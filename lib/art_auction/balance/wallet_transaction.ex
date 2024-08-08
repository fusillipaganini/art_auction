defmodule ArtAuction.Balance.WalletTransaction do
  use Ecto.Schema

  alias ArtAuction.User.Wallet

  @operations [
    donation_to_charity: 1,
    winning_bid: 2,
    cheering_bit: 3,
    subbed: 4,
    manual: 5
  ]

  schema "account_wallet_transactions" do
    belongs_to Wallet, :wallet

    # NOTE: amount value can be negative
    field :amount, :decimal
    field :operation, Ecto.Enum, value: @operations

    timestamps(type: :utc_datetime, on_update: false)
  end
end
