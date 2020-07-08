defmodule Swiss.Ecto.SchemaTest do
  use ExUnit.Case, async: true

  defmodule Swiss.Ecto.TestSchema do
    use Ecto.Schema

    embedded_schema do
      field(:value, :integer, default: 42)
      field(:map, :map)

      embeds_one :simple_embed, SimpleEmbed do
        field(:value, :integer)
      end

      embeds_many :many_embed, ManyEmbed do
        field(:value, :integer)
      end
    end
  end

  describe "to_map/1" do
    test "converts an ecto struct to a map" do
      str = %Swiss.Ecto.TestSchema{
        map: %{"life" => 42},
        simple_embed: %Swiss.Ecto.TestSchema.SimpleEmbed{
          value: 42
        },
        many_embed: [
          %Swiss.Ecto.TestSchema.ManyEmbed{value: 22},
          %Swiss.Ecto.TestSchema.ManyEmbed{value: 12}
        ]
      }

      assert Elixir.Swiss.Ecto.Schema.to_map(str) == %{
               map: %{"life" => 42},
               value: 42,
               simple_embed: %{
                 value: 42
               },
               many_embed: [
                 %{value: 22},
                 %{value: 12}
               ]
             }
    end
  end
end
