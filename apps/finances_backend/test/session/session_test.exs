ExUnit.start()

defmodule FinancesBackend.SessionTest do
  alias FinancesBackend.Session
  use ExUnit.Case, async: true

  @date NaiveDateTime.from_iso8601!("2023-11-07T08:18:00")

  @expected_fields [:id, :user_id, :token, :valid_until, :inserted_at, :updated_at]
  test "should consist of expected fields" do
    fields = Session.__schema__(:fields)
    assert MapSet.new(@expected_fields) == MapSet.new(fields)
  end

  test "should validate user_id presence" do
    session = %Session{}

    params = %{
      token: "123123123",
      valid_until: @date
    }

    result = Session.changeset(session, params)
    assert !result.valid?
    [user_id: {_, [validation: :required]}] = result.errors
  end

  test "should validate token presence" do
    session = %Session{}

    params = %{
      user_id: 123,
      valid_until: @date
    }

    result = Session.changeset(session, params)
    assert !result.valid?
    [token: {_, [validation: :required]}] = result.errors
  end

  test "should validate valid_until presence" do
    session = %Session{}

    params = %{
      user_id: 123,
      token: "123123123"
    }

    result = Session.changeset(session, params)
    assert !result.valid?
    [valid_until: {_, [validation: :required]}] = result.errors
  end
end
