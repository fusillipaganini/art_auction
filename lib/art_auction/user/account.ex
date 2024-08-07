defmodule ArtAuction.User.Account do
  use Ecto.Schema

  schema "accounts" do
    field :display_name, :string

    timestamps()
  end
end