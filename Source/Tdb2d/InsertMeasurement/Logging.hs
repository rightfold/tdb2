{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}

module Tdb2d.InsertMeasurement.Logging
  ( run
  ) where

import Prelude hiding (log)

import Data.Functor.Coyoneda (Coyoneda (..))

import Tdb2d.InsertMeasurement.Dsl (Dsl, Dsl' (..))
import Tdb2d.Support.Logger (Logger, (<<), (+<))

{-# INLINE run #-}
run :: Applicative f => Logger f -> (Dsl a -> f b) -> Dsl a -> f b
run l u (Coyoneda next action) =
  log l action *> u (Coyoneda next action)

{-# INLINE log #-}
log :: Logger f -> Dsl' a -> f ()
log l (InsertMeasurement tags timings) =
  l << "InsertMeasurement"
    +< ("Tags",    tags)
    +< ("Timings", timings)
