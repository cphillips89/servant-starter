{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module Lib
  ( appEntry,
  )
where

import Data.Aeson (ToJSON)
import GHC.Generics (Generic)
import Network.Wai (Application)
import Network.Wai.Handler.Warp (run)
import Servant (Get, JSON, Proxy (..), Server, serve, (:>))

type UserAPI = "users" :> Get '[JSON] [User]

data User = User
  { name :: String,
    email :: String
  }
  deriving (Eq, Show, Generic)

instance ToJSON User

users :: [User]
users =
  [ User "Isaac Newton" "isaac@newton.co.uk",
    User "Albert Einstein" "ae@mc2.org"
  ]

server :: Server UserAPI
server = return users

userAPI :: Proxy UserAPI
userAPI = Proxy

app :: Application
app = serve userAPI server

appEntry :: IO ()
appEntry = run 6868 app