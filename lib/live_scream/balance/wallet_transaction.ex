defmodule LiveScream.Balance.WalletTransaction do
  use Ecto.Schema

  alias Ecto.Changeset
  alias LiveScream.Balance.Wallet

  @type id :: pos_integer()
  @type operation :: :donation_to_charity | :winning_bid | :cheering_bit | :subbed | :manual
  @type t :: %__MODULE__{
          id: id,
          amount: Decimal.t(),
          operation: operation,
          wallet_id: Wallet.id(),
          wallet: Ecto.Schema.belongs_to(Wallet.t()),
          inserted_at: DateTime.t()
        }
  @type changeset :: Changeset.t(%__MODULE__{})

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

  @spec new(Wallet.t() | Wallet.changeset(), operation, Decimal.t()) :: changeset
  def new(wallet, operation, amount) do
    params = %{operation: operation, amount: amount}
    wallet = Wallet.sum(wallet, amount)

    %__MODULE__{}
    |> Changeset.cast(params, [:amount, :operation])
    |> Changeset.validate_required([:amount, :operation])
    |> Changeset.put_assoc(:wallet, wallet)
  end
end
