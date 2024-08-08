defmodule ArtAuction.Migrations.AddWalletAndWalletTransactionTable do
  use Ecto.Migration

  def change do
    create table("account_wallets") do
      add :balance, :decimal, null: false, default: 0

      add :account_id, references("accounts", on_delete: :delete_all, on_update: :restrict),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index("account_wallets", [:account_id])

    create table("account_wallet_transactions") do
      add :amount, :decimal, null: false
      add :operation, :smallint, null: false

      add :wallet_id, references("account_wallets", on_delete: :delete_all, on_update: :restrict),
        null: false

      timestamps(type: :utc_datetime, on_update: false)
    end

    create index("account_wallet_transactions", [:wallet_id])
  end
end
