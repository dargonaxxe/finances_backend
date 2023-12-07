defmodule FinancesBackend.UserTest do
  alias FinancesBackend.User
  use ExUnit.Case, async: true

  @expected_fields [:username, :password, :salt, :id, :inserted_at, :updated_at]

  test "should consist of expected fields" do
    actual_fields =
      User.__schema__(:fields)
      |> MapSet.new()

    assert MapSet.new(@expected_fields) == actual_fields
  end

  test "should be valid" do
    user = %User{}

    attrs = %{
      username: "username",
      password: "passpasspass"
    }

    {:ok, result} = User.changeset(user, attrs)
    assert result.valid?
  end

  test "changeset should require username" do
    user = %User{}

    changeset = %{
      password: "password",
      salt: "salt"
    }

    {:error, :missing_fields} = User.changeset(user, changeset)
  end

  test "changeset should require password" do
    user = %User{}

    changeset = %{
      username: "username"
    }

    {:error, :missing_fields} = User.changeset(user, changeset)
  end

  test "changeset should validate username length" do
    user = %User{}

    attrs = %{
      username: "as",
      password: "passpasspass"
    }

    {:ok, result} = User.changeset(user, attrs)
    assert !result.valid?
    [username: {_, [count: 6, validation: :length, kind: :min, type: :string]}] = result.errors
  end

  test "changeset should validate password length" do
    user = %User{}

    attrs = %{
      username: "username",
      password: "pass"
    }

    {:ok, result} = User.changeset(user, attrs)

    assert !result.valid?
    [pwd_string: {_, [count: 12, validation: :length, kind: :min, type: :string]}] = result.errors
  end

  describe "registration changeset" do
    test "should validate username presence" do
      user = %User{}
      attrs = %{pwd_string: "passpasspass"}

      %{valid?: false, errors: [username: {_, [validation: :required]}]} =
        User.registration_changeset(user, attrs)
    end

    test "should validate pwd_string presence" do
      user = %User{}
      attrs = %{username: "username"}

      %{valid?: false, errors: [pwd_string: {_, [validation: :required]}]} =
        User.registration_changeset(user, attrs)
    end

    test "should validate password length" do
      user = %User{}
      attrs = %{username: "username", pwd_string: "passpass123"}

      %{
        valid?: false,
        errors: [pwd_string: {_, [count: 12, validation: :length, kind: :min, type: :string]}]
      } =
        User.registration_changeset(user, attrs)
    end

    test "should validate username length" do
      user = %User{}
      attrs = %{username: "12345", pwd_string: "passpasspass"}

      %{
        valid?: false,
        errors: [username: {_, [count: 6, validation: :length, kind: :min, type: :string]}]
      } = User.registration_changeset(user, attrs)
    end

    test "should return valid changeset" do
      user = %User{}
      attrs = %{username: "username", pwd_string: "passpasspass"}

      %{valid?: true} = User.registration_changeset(user, attrs)
    end
  end
end
