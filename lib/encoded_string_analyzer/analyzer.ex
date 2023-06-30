defmodule EncodedStringAnalyzer.Analyzer do

  def analyze(string) do
    case string do
      nil -> {:error, "Invalid encoded string, Nil"}
      "" -> {:error, "Invalid encoded string, Empty string"}
      _ -> analyze_string(string)
    end
  end

  defp analyze_string(string) do
    list =
      Regex.replace(~r/0+/, string, "0")
      |> String.split("0")

    IO.inspect(list)
    cond do
      length(list) == 1 ->
        list
        |> List.first
        |> check_type_error(1)
      length(list) == 2 ->
        [first, last] = list

        if first == "" && last == "" do
          {:error, "Invalid encoded string, only zeros"}
        else
          {atom_first, value_first} = check_type_error(first, 2)
          {atom_last, value_last} = check_type_error(last, 2)

          cond do
            atom_first == :num && atom_last == :num ->
              {:error, "Invalid encoded string, Two or more IDs"}
            atom_first == :str && atom_last == :str ->
              {:error, "Invalid encoded string, ID is missing"}
            atom_first == :num && atom_last == :str ->
              if value_last == "" do
                {:error, "Invalid encoded string, First Name and Last Name are missing"}
              else
                {:ok, %{first_name: value_last, last_name: "", id: value_first}}
              end
            atom_first == :str && atom_last == :num ->
              if value_first == "" do
                {:error, "Invalid encoded string, First Name and Last Name are missing"}
              else
                {:ok, %{first_name: value_first, last_name: "", id: value_last}}
              end
          end
        end
      length(list) == 3 ->
        [first, middle, last] = list
        {atom_first, value_first} = check_type_error(first, 3)
        {atom_middle, value_middle} = check_type_error(middle, 3)
        {atom_last, value_last} = check_type_error(last, 3)

        cond do
          atom_first == :num && atom_middle == :num && atom_last == :num ->
            {:error, "Invalid encoded string, Two or more IDs"}

          atom_first == :num && atom_middle == :num && atom_last == :str ->
            {:error, "Invalid encoded string, Two or more IDs"}

          atom_first == :num && atom_middle == :str && atom_last == :num ->
            {:error, "Invalid encoded string, Two or more IDs"}

          atom_first == :str && atom_middle == :num && atom_last == :num ->
            {:error, "Invalid encoded string, Two or more IDs"}

          atom_first == :str && atom_middle == :num && atom_last == :str ->
            {:ok, %{first_name: value_first, last_name: value_last, id: value_middle}}

          atom_first == :str && atom_middle == :str && atom_last == :num ->
            {:ok, %{first_name: value_first, last_name: value_middle, id: value_last}}

          atom_first == :num && atom_middle == :str && atom_last == :str ->
            {:ok, %{first_name: value_middle, last_name: value_last, id: value_first}}

          atom_first == :str && atom_middle == :str && atom_last == :str ->
            {:error, "Invalid encoded string, ID is missing"}
        end
      true ->
        {:error, "Invalid encoded string, More than three fields"}
    end
  end



  defp check_type_error(string, length_list) do
    if check_is_number?(string) do
      if length_list == 1 do
        {:error, "Invalid encoded string, First Name and Last Name are missing"}
      else
        {:num, string}
      end
    else
      if length_list == 1 do
        {:error, "Invalid encoded string, ID is missing"}
      else
        {:str, string}
      end
    end
  end

  defp check_is_number?(string) do
    case Integer.parse(string) do
      :error ->
        false
        _ ->
        true
    end
  end
end
