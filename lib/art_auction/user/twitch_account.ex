defmodule ArtAuction.User.TwitchAccount do
  use Ecto.Schema

  alias ArtAuction.User.Account
  alias ArtAuction.User.TwitchAccessToken

  @type id :: String.t()
  @type t :: %__MODULE__{
          twitch_user_id: id,
          twitch_username: String.t(),
          account_id: Account.id(),
          account: Ecto.Schema.belongs_to(Account.t()),
          access_tokens: Ecto.Schema.has_many(TwitchAccessToken.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @primary_key false
  schema "twitch_accounts" do
    # NOTE: Twitch uses integers as the user id but it expects such id to be treated as an opaque string.
    field :twitch_user_id, :string, primary_key: true
    field :twitch_username, :string

    belongs_to :account, Account

    has_many :access_tokens, TwitchAccessToken,
      foreign_key: :twitch_user_id,
      references: :twitch_user_id

    timestamps(type: :utc_datetime)
  end
end
