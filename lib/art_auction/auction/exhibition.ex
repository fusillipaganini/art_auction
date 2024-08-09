defmodule ArtAuction.Auction.Exhibition do
  use Ecto.Schema

  @type id :: pos_integer()
  @type t :: %__MODULE__{
          id: id,
          name: String.t(),
          status: :draft | :open | :finished,
          description: String.t(),
          starts_at: DateTime.t() | nil,
          private: boolean(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "auction_exhibitions" do
    field :name, :string
    field :status, Ecto.Enum, values: [draft: 1, open: 2, finished: 3]
    field :description, :string

    field :starts_at, :utc_datetime

    # A private exhibition is one that won't appear listed on the website and will only appear during the
    # relevant stream event (and to admins and indirectly to whomever wins lots on that exhibition)
    # REVIEW: maybe we want to have more than one type of "private" stream, considering that the concept of
    #   subs-only streams exist, we can also support subs-only auctions ?
    field :private, :boolean

    timestamps(type: :utc_datetime)
  end
end
