defmodule LiveScream.Balance.WalletTransaction do
  use Ecto.Schema

  alias LiveScream.Balance.Wallet

  @type id :: pos_integer()
  @type t :: %__MODULE__{
          id: id,
          amount: Decimal.t(),
          operation: :donation_to_charity | :winning_bid | :cheering_bit | :subbed | :manual,
          wallet_id: Wallet.id(),
          wallet: Ecto.Schema.belongs_to(Wallet.t()),
          inserted_at: DateTime.t()
        }

  @operations [
    donation_to_charity: 1,
    winning_bid: 2,
    cheering_bit: 3,
    subbed: 4,
    manual: 5
  ]

  schema "account_wallet_transactions" do
    # NOTE: amount value can be negative
    field :amount, :decimal
    field :operation, Ecto.Enum, values: @operations

    belongs_to :wallet, Wallet

    timestamps(type: :utc_datetime, on_update: false)
  end
end
