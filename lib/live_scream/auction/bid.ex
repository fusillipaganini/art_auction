defmodule LiveScream.Auction.Bid do
  use Ecto.Schema

  import Ecto.Query, only: [where: 3]

  alias Ecto.Changeset
  alias LiveScream.Auction.Lot
  alias LiveScream.User.Account

  @type id :: pos_integer()
  @type t :: %__MODULE__{
          id: id,
          amount: Decimal.t(),
          anonymous: boolean(),
          status: :valid | :rejected | :winner | :unfulfiled | :expired,
          account_id: Account.id(),
          account: Ecto.Schema.belongs_to(Account.t()),
          lot_id: Lot.id(),
          lot: Ecto.Schema.belongs_to(Lot.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
  @type changeset :: Changeset.t(%__MODULE__{})

  schema "auction_bids" do
    field :amount, :decimal
    field :anonymous, :boolean

    field :status, Ecto.Enum,
      values: [valid: 1, rejected: 2, winner: 3, unfulfiled: 4, expired: 5]

    belongs_to :account, Account
    belongs_to :lot, Lot

    timestamps(type: :utc_datetime)
  end

  @spec new(Lot.t(), Account.t(), Decimal.t()) :: changeset
  def new(lot, account, amount) do
    params = %{
      amount: amount,
      anonymous: account.anonymize,
      status: :valid
    }

    %__MODULE__{}
    |> Changeset.cast(params, [:amount, :anonymous, :status])
    |> Changeset.put_assoc(:account, account)
    |> Changeset.put_assoc(:lot, lot)
    |> validate_lot_active(lot)
    |> Changeset.validate_number(:amount, greater_than_or_equal_to: lot.starting_bid)
    |> Changeset.prepare_changes(fn changeset ->
      # Just a simple consistency check to ensure that the bid is valid
      covered_range = Decimal.sub(amount, lot.increment)

      higher_bid =
        Bid
        |> where([x], x.lot_id == ^lot.id)
        |> where([x], x.status == ^:valid)
        |> where([x], x.amount > ^covered_range)

      # Honestly I don't like having this here but for now it will do
      if changeset.repo.exists?(higher_bid) do
        Changeset.add_error(
          changeset,
          :amount,
          "a higher bid exists already or the increment wasn't respected"
        )
      else
        # Bid is valid and should be commited
        changeset
      end
    end)
  end

  defp validate_lot_active(changeset, lot) do
    if lot.status == :active do
      changeset
    else
      Changeset.add_error(changeset, :lot, "must be active")
    end
  end
end
