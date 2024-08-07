defmodule ArtAuction.Migrations.AddAccountsTable do
  use Ecto.Migration

  def change do
    create table("accounts") do
      add :display_name, :string, null: false

      timestamps()
    end
  end
end