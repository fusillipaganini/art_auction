defmodule ArtAuction.User.TwitchAccessToken do
  use Ecto.Schema

  alias ArtAuction.User.TwitchAccount

  @type id :: pos_integer()
  @type t :: %__MODULE__{
          id: id,
          access_token: String.t(),
          refresh_token: String.t() | nil,
          expires_at: DateTime.t(),
          validate_at: DateTime.t() | nil,
          status: :new | :valid | :expired,
          twitch_user_id: TwitchAccount.id(),
          twitch_account: Ecto.Schema.belongs_to(TwitchAccount.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "twitch_access_tokens" do
    field :access_token, :string, redact: true
    field :refresh_token, :string, redact: true

    field :expires_at, :utc_datetime
    field :validate_at, :utc_datetime
    field :status, Ecto.Enum, values: [new: 1, valid: 2, expired: 3], default: :new

    belongs_to :twitch_account, TwitchAccount,
      foreign_key: :twitch_user_id,
      references: :twitch_user_id,
      type: :string

    timestamps(type: :utc_datetime)
  end
end
