{-# LANGUAGE FlexibleContexts #-}

module Tdb2d.Core
  ( run
  ) where

import Control.Monad.State.Class (MonadState)

import Tdb2d.Dsl (Dsl)
import Tdb2d.Support.Database (Database)

import qualified Tdb2d.InsertMeasurement.Core as InsertMeasurement.Core

{-# INLINE run #-}
run :: MonadState Database f => Dsl a -> f a
run = InsertMeasurement.Core.run
