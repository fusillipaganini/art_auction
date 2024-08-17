defmodule LiveScream.User.Account do
  use Ecto.Schema

  alias Ecto.Changeset
  alias LiveScream.User.TwitchAccount

  @type id :: pos_integer()
  @type t :: %__MODULE__{
          id: id,
          display_name: String.t(),
          anonymize: boolean(),
          twitch_account: Ecto.Schema.has_one(TwitchAccount.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
  @type changeset :: Ecto.Changeset.t(%__MODULE__{})

  schema "accounts" do
    field :display_name, :string
    field :anonymize, :boolean, default: false

    has_one :twitch_account, TwitchAccount

    timestamps(type: :utc_datetime)
  end

  @spec changeset(%__MODULE__{} | changeset, map()) :: changeset
  def changeset(data, params) do
    data
    |> Changeset.cast(params, [:display_name, :anonymize])
    |> Changeset.validate_required([:display_name, :anonymize])
  end
end
