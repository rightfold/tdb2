{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE StrictData #-}
{-# LANGUAGE TemplateHaskell #-}

module Tdb2d.Support.Database
  ( -- * Database
    Database
  , Measurement (..)
  , empty
  , insert

    -- * Optics
  , measurements
  , tagged
  , measurementTags
  , measurementTimings
  ) where

import Control.Lens (Traversal', filtered, makeLenses, makePrisms, view)
import Data.Set (Set)
import Data.Text (Text)
import Data.Vector (Vector)

import qualified Data.Set as Set

--------------------------------------------------------------------------------
-- Database

newtype Database =
  Database [Measurement]

data Measurement =
  Measurement
    { _measurementTags    :: Set Text
    , _measurementTimings :: Vector Double }
  deriving stock (Show)

{-# INLINE empty #-}
empty :: Database
empty = Database []

{-# INLINE insert #-}
insert :: Measurement -> Database -> Database
insert m (Database ms) = Database (m : ms)

--------------------------------------------------------------------------------
-- Optics

$(makePrisms ''Database)
$(makeLenses ''Measurement)

{-# INLINE measurements #-}
measurements :: Traversal' Database [Measurement]
measurements = _Database

{-# INLINE tagged #-}
tagged :: Set Text -> Traversal' Database Measurement
tagged ts = measurements . traverse . filtered p
              where p = Set.isSubsetOf ts . view measurementTags
