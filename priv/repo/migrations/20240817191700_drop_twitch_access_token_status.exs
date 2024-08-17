defmodule ArtAuction.Migrations.DropTwitchAccessTokenStatus do
  use Ecto.Migration

  def change do
    alter table("twitch_access_tokens") do
      remove :status, :smallint
    end
  end
end
