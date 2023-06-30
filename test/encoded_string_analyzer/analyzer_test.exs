defmodule EncodedStringAnalyzer.AnalyzerTest do
  use ExUnit.Case

  import EncodedStringAnalyzer.Analyzer

  describe "Testing Analyzer" do
    test "Accepted encoded string" do
      expected = {:ok, %{first_name: "Robert", last_name: "Smith", id: "123"}}
      assert expected == analyze("Robert000Smith000123")
    end

    test "Only First Name and ID" do
      expected = {:ok, %{first_name: "Robert", last_name: "", id: "123"}}
      assert expected == analyze("Robert000123")
      assert expected == analyze("Robert000123000")
      assert expected == analyze("123000Robert000")
      assert expected == analyze("123000Robert")
    end

    test "Only Last Name and ID" do
      expected = {:ok, %{first_name: "", last_name: "Smith", id: "123"}}
      assert expected == analyze("000Smith000123")
    end

    test "ID in the middle" do
      expected = {:ok, %{first_name: "Robert", last_name: "Smith", id: "123"}}
      assert expected == analyze("Robert00012300Smith")
    end

    test "ID in the beginning" do
      expected = {:ok, %{first_name: "Robert", last_name: "Smith", id: "123"}}
      assert expected == analyze("12300Robert000Smith")
    end

    test "Rejected encoded string (More than three fields)" do
      expected = {:error, "Invalid encoded string, More than three fields"}
      assert expected == analyze("Robert000Smith000123000456")
    end

    test "Rejected encoded string (Two or more IDs)" do
      expected = {:error, "Invalid encoded string, Two or more IDs"}
      assert expected == analyze("Smith000123000456")
      assert expected == analyze("123000Smith000456")
      assert expected == analyze("123000456000Smith")
      assert expected == analyze("123000456")
      assert expected == analyze("123000456000789")
    end

    test "Rejected encoded string (ID not found)" do
      expected = {:error, "Invalid encoded string, ID is missing"}
      assert expected == analyze("Robert000Smith")
      assert expected == analyze("Robert000Smith000")
      assert expected == analyze("000Smith000")
    end

    test "Rejected encoded string (First Name and Last Name not found)" do
      expected = {:error, "Invalid encoded string, First Name and Last Name are missing"}
      assert expected == analyze("000123")
      assert expected == analyze("123")
    end

    test "Rejected encoded string (only zeros)" do
      expected = {:error, "Invalid encoded string, only zeros"}
      assert expected == analyze("0000")
      assert expected == analyze("0")
    end

    test "Rejected encoded string (Empty string)" do
      expected = {:error, "Invalid encoded string, Empty string"}
      assert expected == analyze("")
    end

    test "Rejected encoded string (Nil)" do
      expected = {:error, "Invalid encoded string, Nil"}
      assert expected == analyze(nil)
    end
  end
end
