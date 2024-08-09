defmodule ArtAuction.Migrations.MoveTwitchAccountDataToOwnTable do
  use Ecto.Migration

  def change do
    create table("twitch_accounts", primary_key: false) do
      add :twitch_user_id, :string, primary_key: true
      add :twitch_username, :string, null: false
      add :display_name, :string, null: false

      add :account_id, references("accounts", on_delete: :delete_all, on_update: :restrict),
        null: false

      timestamps(type: :utc_datetime)
    end

    # Technically by not being an UNIQUE, it allows an account to have more than one twitch account linked
    # but the system won't allow this to happen at least for now; maybe in the future ?
    create index("twitch_accounts", ["account_id"])
    create index("twitch_accounts", ["twitch_username"])

    alter table("twitch_access_tokens") do
      remove :twitch_username, :string

      remove :account_id, references("accounts", on_delete: :delete_all, on_update: :restrict),
        null: false

      modify :twitch_user_id,
             references("twitch_accounts",
               column: :twitch_user_id,
               type: :string,
               on_delete: :delete_all,
               on_update: :restrict
             ),
             from: {:string, null: true}
    end

    create index("twitch_access_tokens", ["twitch_user_id"])
  end
end
