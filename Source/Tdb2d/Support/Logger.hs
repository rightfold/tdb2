{-# LANGUAGE DerivingStrategies #-}

module Tdb2d.Support.Logger
  ( -- * Loggers
    Logger
  , Logger' (..)
  , printer

    -- * Records
  , Record (..)
  , (+<)
  ) where

import Data.Aeson (ToJSON, toJSON)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.String (IsString (..))
import Data.Text (Text)

import qualified Data.Aeson as Aeson

infixr 0 <<
infixl 1 +<

--------------------------------------------------------------------------------
-- Loggers

type Logger f =
  Logger' f Record

-- |
-- A logger emits given information, not producing any result.
newtype Logger' f a =
  Logger' { (<<) :: a -> f () }

-- |
-- Logger that uses 'print'.
{-# INLINE printer #-}
printer :: (MonadIO f, Show a) => Logger' f a
printer = Logger' $ liftIO . print

--------------------------------------------------------------------------------
-- Records

-- |
-- A record pairs an identifier with fields that contain extra information. The
-- identifier is typically a static string in Pascal case.
data Record =
  Record Text [(Text, Aeson.Value)]
  deriving stock (Eq, Show)

-- |
-- Create a record with no fields; the string is used as the identifier.
instance IsString Record where
  {-# INLINE fromString #-}
  fromString s = Record (fromString s) []

-- |
-- Add a field to a record.
{-# INLINE (+<) #-}
(+<) :: ToJSON a => Record -> (Text, a) -> Record
(+<) ~(Record i fs) ~(k, v) = Record i ((k, toJSON v) : fs)
