defmodule ArtAuction.Migrations.AddAuctionContextTables do
  use Ecto.Migration

  def change do
    create table("auction_exhibitions") do
      add :name, :string, null: false
      add :status, :smallint, null: false
      add :description, :string, null: false, default: ""
      add :starts_at, :utc_datetime
      add :private, :boolean, null: false, default: false

      timestamps(type: :utc_datetime)
    end

    create index("auction_exhibitions", ["starts_at"],
             where: "private IS false AND status = 2",
             name: "auction_exhibitions_next_public_open_idx"
           )

    create index("auction_exhibitions", ["starts_at"],
             where: "private IS false AND status = 3",
             name: "auction_exhibitions_last_public_finished_idx"
           )

    create table("auction_lots") do
      add :number, :smallint, null: false
      add :name, :string, null: false
      add :description, :string, null: false, default: ""
      add :status, :smallint, null: false
      add :starting_bid, :decimal, null: false
      add :increment, :decimal, null: false

      add :exhibition_id,
          references("auction_exhibitions", on_delete: :delete_all, on_update: :restrict),
          null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index("auction_lots", ["exhibition_id", "number"])

    create table("auction_bids") do
      # For later, add trigger to ensure that no other entry with same `lot_id` and higher or equal amount
      # exists when inserting a bid
      add :amount, :decimal, null: false
      add :anonymous, :boolean, null: false, default: false
      add :status, :smallint, null: false

      add :account_id, references("accounts", on_delete: :delete_all, on_update: :restrict),
        null: false

      add :lot_id, references("auction_lots", on_delete: :delete_all, on_update: :restrict),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index("auction_bids", ["account_id", "inserted_at"])

    # We only care about the bids that are on active lots; archived bets will only be very rarely checked by
    # admins so we can let them be full table scans for now
    create index("auction_bids", ["lot_id", "inserted_at"], where: "status = 1")
  end
end
