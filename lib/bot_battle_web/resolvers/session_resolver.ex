defmodule BotBattleWeb.Resolvers.SessionResolver do
  
  alias BotBattle.{Accounts, Guardian}

  def login_user(_,%{input: input},_) do
    # check if user is in our database
    # if a user is registered we wanna return a token
    # and we want to return the user
    IO.inspect(input)
    case Accounts.Session.authenticate(input) do
      {:ok, user} -> 
        Guardian.encode_and_sign(user)
    end
    
    with {:ok, user} <- Accounts.Session.authenticate(input), 
         {:ok, jwt_token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt_token, user: user}}
    end
    |> case do
      {:error, error} -> 
        {:error, error}
      other -> 
        other
    end
  end
end