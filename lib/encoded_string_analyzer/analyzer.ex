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

    case length(list) do
      1 -> analyze_list(list)
      2 -> analyze_list(list)
      3 -> analyze_list(list)
      _ -> {:error, "Invalid encoded string, More than three fields"}
    end
  end

  defp analyze_list([first]), do: check_type_error(first, 1)

  defp analyze_list([first, last]) do
    case {check_type_error(first, 2), check_type_error(last, 2)} do
      {{:num, _}, {:num, _}} -> {:error, "Invalid encoded string, Two or more IDs"}
      {{:str, ""}, {:str, ""}} -> {:error, "Invalid encoded string, only zeros"}
      {{:str, _}, {:str, _}} -> {:error, "Invalid encoded string, ID is missing"}
      {{:num, _}, {:str, ""}} -> {:error, "Invalid encoded string, First Name and Last Name are missing"}
      {{:num, value_first}, {:str, value_last}} -> {:ok, %{first_name: value_last, last_name: "", id: value_first}}
      {{:str, ""}, {:num, _}} -> {:error, "Invalid encoded string, First Name and Last Name are missing"}
      {{:str, value_first}, {:num, value_last}} -> {:ok, %{first_name: value_first, last_name: "", id: value_last}}
    end
  end

  defp analyze_list([first, middle, last]) do
    case {check_type_error(first, 3), check_type_error(middle, 3), check_type_error(last, 3)} do
      {{:num, _}, {:num, _}, {:num, _}} -> {:error, "Invalid encoded string, Two or more IDs"}
      {{:num, _}, {:num, _}, {:str, _}} -> {:error, "Invalid encoded string, Two or more IDs"}
      {{:num, _}, {:str, _}, {:num, _}} -> {:error, "Invalid encoded string, Two or more IDs"}
      {{:str, _}, {:num, _}, {:num, _}} -> {:error, "Invalid encoded string, Two or more IDs"}
      {{:str, _}, {:num, _}, {:str, _}} -> {:ok, %{first_name: first, last_name: last, id: middle}}
      {{:str, _}, {:str, _}, {:num, _}} -> {:ok, %{first_name: first, last_name: middle, id: last}}
      {{:num, _}, {:str, _}, {:str, _}} -> {:ok, %{first_name: middle, last_name: last, id: first}}
      {{:str, _}, {:str, _}, {:str, _}} -> {:error, "Invalid encoded string, ID is missing"}
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
