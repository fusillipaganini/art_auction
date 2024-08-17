defmodule LiveScream.User.TwitchAccessToken do
  use Ecto.Schema

  alias Ecto.Changeset
  alias LiveScream.User.TwitchAccount

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
  @type changeset :: Changeset.t(%__MODULE__{})

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

  @spec new(TwitchAccount.t() | TwitchAccount.changeset(), map()) :: changeset
  def new(twitch_account, params) do
    %__MODULE__{}
    |> Changeset.cast(params, [:access_token, :refresh_token, :expires_at])
    |> Changeset.put_assoc(:twitch_account, twitch_account)
    |> Changeset.validate_required([:access_token, :expires_at])
  end

  @spec validation_action(t) :: :expire | :refresh | :validate | :pass
  def validation_action(access_token = %__MODULE__{}) do
    now = DateTime.utc_now()
    expired? = DateTime.after?(now, access_token.expires_at)

    revalidate? =
      is_nil(access_token.validate_at) || DateTime.after?(now, access_token.validate_at)

    cond do
      access_token.status == :expired ->
        :expire

      expired? and is_nil(access_token.refresh_token) ->
        :expire

      expired? ->
        :refresh

      access_token.status == :new ->
        :validate

      revalidate? ->
        :validate

      :else ->
        :pass
    end
  end

  @spec mark_expired(t | changeset) :: changeset
  def mark_expired(access_token) do
    Changeset.change(access_token, %{status: :expired, validate_at: nil})
  end

  @spec mark_validated(t | changeset) :: changeset
  def mark_validated(access_token) do
    Changeset.change(access_token, %{
      status: :valid,
      validate_at: DateTime.add(DateTime.utc_now(), 1, :hour)
    })
  end
end
