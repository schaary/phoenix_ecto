if Code.ensure_loaded?(Poison) do
  defimpl Poison.Encoder, for: [Ecto.Date, Ecto.Time, Ecto.DateTime] do
    def encode(dt, _opts), do: <<?", @for.to_iso8601(dt)::binary, ?">>
  end

  defimpl Poison.Encoder, for: Decimal do
    def encode(decimal, _opts), do: <<?", Decimal.to_string(decimal)::binary, ?">>
  end

  defimpl Poison.Encoder, for: Ecto.Changeset do
    def encode(%{errors: errors}, opts) do
      errors
      |> Enum.reverse()
      |> merge_error_keys()
      |> Poison.Encoder.encode(opts)
    end

    defp merge_error_keys(errors) do
      Enum.reduce(errors, %{}, fn({k, v}, acc ) ->
         Map.update(acc, k, [v], &[v|&1])
       end)
    end
  end
end
