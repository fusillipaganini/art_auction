defmodule LiveScream.User.TwitchAccount do
  use Ecto.Schema

  alias Ecto.Changeset
  alias LiveScream.User.Account
  alias LiveScream.User.TwitchAccessToken

  @type id :: String.t()
  @type username :: String.t()
  @type t :: %__MODULE__{
          twitch_user_id: id,
          twitch_username: username,
          account_id: Account.id(),
          account: Ecto.Schema.belongs_to(Account.t()),
          access_tokens: Ecto.Schema.has_many(TwitchAccessToken.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
  @type changeset :: Changeset.t(%__MODULE__{})

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

  @spec new(id, username) :: changeset
  def new(id, username) do
    params = %{
      twitch_user_id: id,
      twitch_username: username,
      account: %{
        display_name: username
      }
    }

    %__MODULE__{}
    |> Changeset.cast(params, [:twitch_user_id, :twitch_username])
    |> Changeset.cast_assoc(:account)
    |> Changeset.validate_required([:twitch_user_id, :twitch_username])
  end
end
