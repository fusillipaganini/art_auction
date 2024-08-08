defmodule ArtAuction.Balance.Wallet do
  use Ecto.Schema

  alias ArtAuction.Balance.WalletTransaction
  alias ArtAuction.User.Account

  schema "account_wallets" do
    belongs_to Account, :account

    # Currency: $ 1.00, pts 1000
    field :balance, :decimal

    has_many WalletTransaction, :transactions

    timestamps(type: :utc_datetime)
  end
end
