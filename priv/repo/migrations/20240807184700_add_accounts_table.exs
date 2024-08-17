defmodule LiveScream.Migrations.AddAccountsTable do
  use Ecto.Migration

  def change do
    create table("accounts") do
      add :display_name, :string, null: false
      add :anonymize, :boolean, null: false, default: false

      timestamps(type: :utc_datetime)
    end
  end
end
