{-# LANGUAGE FlexibleContexts #-}

module Tdb2d.Api
  ( Api
  , server
  ) where

import Control.Monad.Free.Class (MonadFree)
import Servant.Server (ServerT)

import qualified Tdb2d.InsertMeasurement.Api as InsertMeasurement.Api
import qualified Tdb2d.InsertMeasurement.Dsl as InsertMeasurement.Dsl

type Api =
  InsertMeasurement.Api.Api

{-# INLINE server #-}
server :: MonadFree InsertMeasurement.Dsl.Dsl f => ServerT Api f
server = InsertMeasurement.Api.server
