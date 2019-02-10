{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}

module Tdb2d.InsertMeasurement.Dsl
  ( Dsl
  , Dsl' (..)
  , insertMeasurement
  ) where

import Control.Monad.Free.Class (MonadFree, liftF)
import Data.Functor.Coyoneda (Coyoneda, liftCoyoneda)
import Data.Set (Set)
import Data.Text (Text)
import Data.Vector (Vector)

type Dsl =
  Coyoneda Dsl'

data Dsl' :: * -> * where
  InsertMeasurement :: Set Text -> Vector Double -> Dsl' ()

{-# INLINE insertMeasurement #-}
insertMeasurement :: MonadFree Dsl f => Set Text -> Vector Double -> f ()
insertMeasurement tags timings =
  liftF . liftCoyoneda $
    InsertMeasurement tags timings
