defmodule LiveScream.Balance.Wallet do
  use Ecto.Schema

  alias Ecto.Changeset
  alias LiveScream.Balance.WalletTransaction
  alias LiveScream.User.Account

  @type id :: pos_integer()
  @type t :: %__MODULE__{
          id: id,
          balance: Decimal.t(),
          account_id: Account.id(),
          account: Ecto.Schema.belongs_to(Account.t()),
          transactions: Ecto.Schema.has_many(WalletTransaction.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
  @type changeset :: Changeset.t(%__MODULE__{})

  schema "account_wallets" do
    # Currency: $ 1.00, pts 1000
    field :balance, :decimal

    belongs_to :account, Account
    # The sum of all transactions should result in `balance`
    has_many :transactions, WalletTransaction

    timestamps(type: :utc_datetime)
  end

  @spec new(Account.t() | Account.changeset()) :: changeset
  def new(account) do
    %__MODULE__{}
    |> Changeset.change(%{balance: 0})
    |> Changeset.put_assoc(:account, account)
  end

  @spec sum(t | changeset, Decimal.t()) :: changeset
  def sum(wallet, value) do
    changeset = Changeset.change(wallet)
    balance = Changeset.get_field(changeset, :balance)

    Changeset.put_change(changeset, :balance, Decimal.add(balance, value))
  end
end
