defmodule ArtAuction.User.Account do
  use Ecto.Schema

  alias ArtAuction.User.TwitchAccount

  @type id :: pos_integer()
  @type t :: %__MODULE__{
          id: id,
          display_name: String.t(),
          anonymize: boolean(),
          twitch_account: Ecto.Schema.has_one(TwitchAccount.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "accounts" do
    field :display_name, :string
    field :anonymize, :boolean, default: false

    has_one :twitch_account, TwitchAccount

    timestamps(type: :utc_datetime)
  end
end
