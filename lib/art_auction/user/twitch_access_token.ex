defmodule ArtAuction.User.TwitchAccessToken do
  use Ecto.Schema

  alias ArtAuction.User.Account

  @type id :: pos_integer()

  @type t :: %__MODULE__{
          id: id,
          access_token: String.t(),
          refresh_token: String.t() | nil,
          twitch_user_id: String.t() | nil,
          twitch_username: String.t() | nil,
          expires_at: DateTime.t(),
          validate_at: DateTime.t() | nil,
          status: :new | :valid | :invalid,
          account_id: Account.id() | nil,
          account: Ecto.Schema.belongs_to(Account.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @type new :: %__MODULE__{
          twitch_user_id: nil,
          twitch_username: nil,
          validate_at: nil,
          status: :new,
          account_id: nil
        }

  schema "twitch_access_tokens" do
    field :access_token, :string, redact: true
    field :refresh_token, :string, redact: true

    # NOTE: Twitch uses integers as the user id but it expects such id to be treated as an opaque string.
    field :twitch_user_id, :string
    field :twitch_username, :string
    field :expires_at, :utc_datetime
    field :validate_at, :utc_datetime
    field :status, Ecto.Enum, values: [new: 1, valid: 2, expired: 3], default: :new

    belongs_to :account, Account

    timestamps(type: :utc_datetime)
  end
end
