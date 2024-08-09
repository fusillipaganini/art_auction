defmodule ArtAuction.User.Account do
  use Ecto.Schema

  alias ArtAuction.User.TwitchAccessToken

  @type id :: pos_integer()

  @type t :: %__MODULE__{
          id: id,
          display_name: String.t(),
          anonymize: boolean(),
          twitch_access_tokens: Ecto.Schema.has_many(TwitchAccessToken.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "accounts" do
    field :display_name, :string
    field :anonymize, :boolean, default: false

    has_many :twitch_access_tokens, TwitchAccessToken

    timestamps(type: :utc_datetime)
  end
end
