{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

module Main
  ( main
  ) where

import Control.Concurrent.STM (TVar)
import Control.Monad.Free (Free, foldFree)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Trans.State.Strict (runState)
import Data.Proxy (Proxy (..))

import qualified Control.Concurrent.STM as Stm
import qualified Network.Wai.Handler.Warp as Warp
import qualified Servant.Server as Servant

import Tdb2d.Dsl (Dsl)
import Tdb2d.Support.Database (Database)
import Tdb2d.Support.Logger (Logger)

import qualified Tdb2d.Api as Api
import qualified Tdb2d.Core as Core
import qualified Tdb2d.Logging as Logging
import qualified Tdb2d.Support.Database as Database
import qualified Tdb2d.Support.Logger as Logger

main :: IO ()
main = do
  let l = Logger.printer
  db <- Stm.newTVarIO Database.empty

  let api = Proxy @Api.Api
  let app = Servant.serve api $
              Servant.hoistServer api (interpret l db) Api.server
  Warp.run 8000 app

interpret :: forall f a. MonadIO f => Logger f -> TVar Database -> Free Dsl a -> f a
interpret l db =
  foldFree $ loggingRun coreRun
  where
  loggingRun :: (Dsl b -> f c) -> Dsl b -> f c
  loggingRun = Logging.run l

  coreRun :: Dsl b -> f b
  coreRun = liftIO . Stm.atomically .
              Stm.stateTVar db . runState . Core.run
