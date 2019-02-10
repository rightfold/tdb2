{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}

module Tdb2d.InsertMeasurement.Core
  ( run
  ) where

import Control.Lens ((%=))
import Control.Monad.State.Class (MonadState)
import Control.Monad.Trans.State (State)
import Data.Functor.Coyoneda (Coyoneda (..))

import Tdb2d.InsertMeasurement.Dsl (Dsl, Dsl' (..))
import Tdb2d.Support.Database (Database, Measurement (..))

import qualified Tdb2d.Support.Database as Database

{-# SPECIALIZE run :: Dsl a -> State Database a #-}
run :: MonadState Database f => Dsl a -> f a
run (Coyoneda next action) = case action of
  InsertMeasurement tags timings -> do
    id %= Database.insert (Measurement tags timings)
    pure $ next ()
