defmodule LiveScream.Migrations.AddTwitchAccessTokensTable do
  use Ecto.Migration

  def change do
    create table("twitch_access_tokens") do
      add :access_token, :string, null: false
      add :refresh_token, :string
      add :twitch_user_id, :string
      add :twitch_username, :string
      add :expires_at, :utc_datetime, null: false
      add :validate_at, :utc_datetime
      add :status, :smallint

      add :account_id, references("accounts", on_delete: :delete_all, on_update: :restrict)

      timestamps(type: :utc_datetime)
    end
  end
end
