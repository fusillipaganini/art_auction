defmodule LiveScream.Balance.Wallet do
  use Ecto.Schema

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

  schema "account_wallets" do
    # Currency: $ 1.00, pts 1000
    field :balance, :decimal

    belongs_to :account, Account
    has_many :transactions, WalletTransaction

    timestamps(type: :utc_datetime)
  end
end
