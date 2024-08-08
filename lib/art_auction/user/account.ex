defmodule ArtAuction.User.Account do
  use Ecto.Schema

  alias ArtAuction.User.TwitchAccessToken

  @type id :: pos_integer()

  @type t :: %__MODULE__{
    display_name: String.t,
    twitch_access_tokens: Ecto.Schema.has_many(TwitchAccessToken.t),
    inserted_at: DateTime.t,
    updated_at: DateTime.t
  }

  schema "accounts" do
    field :display_name, :string

    has_many TwitchAccessToken, :twitch_access_tokens

    timestamps(type: :utc_datetime)
  end
end