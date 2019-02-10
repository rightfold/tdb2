module Tdb2d.Logging
  ( run
  ) where

import Tdb2d.InsertMeasurement.Dsl (Dsl)
import Tdb2d.Support.Logger (Logger)

import qualified Tdb2d.InsertMeasurement.Logging as InsertMeasurement.Logging

{-# INLINE run #-}
run :: Applicative f => Logger f -> (Dsl a -> f b) -> Dsl a -> f b
run = InsertMeasurement.Logging.run
