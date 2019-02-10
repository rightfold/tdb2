{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeOperators #-}

module Tdb2d.InsertMeasurement.Api
  ( Api
  , Req (..)
  , Res (..)
  , server
  ) where

import Control.Monad.Free.Class (MonadFree)
import Data.Aeson (FromJSON, ToJSON)
import Data.Set (Set)
import Data.Text (Text)
import Data.Vector (Vector)
import GHC.Generics (Generic)
import Servant.API (type (:>), JSON, Post, ReqBody)
import Servant.Server (ServerT)

import Tdb2d.InsertMeasurement.Dsl (Dsl, insertMeasurement)
import Tdb2d.Support.Aeson (StripPrefix (..))

type Api =
  "InsertMeasurement" :>
  ReqBody '[JSON] Req :>
  Post '[JSON] Res

data Req =
  Req
    { reqTags    :: Set Text
    , reqTimings :: Vector Double }
  deriving stock (Generic, Show)
  deriving FromJSON via StripPrefix "req" Req

data Res =
  Res
  deriving stock (Generic, Show)
  deriving anyclass (ToJSON)

{-# INLINE server #-}
server :: MonadFree Dsl f => ServerT Api f
server req = Res <$ insertMeasurement (reqTags req) (reqTimings req)
