{-# LANGUAGE OverloadedStrings #-}

-- | Encoding things into JSON values in TCM

module Agda.Interaction.Encoding where

import Control.Monad (sequence, liftM2)
import Data.Aeson
import Data.Aeson.Types (Pair)
import Data.Text (Text)

import Agda.TypeChecking.Monad
import Agda.TypeChecking.Pretty (PrettyTCM(..))
import Agda.Utils.Pretty

---------------------------------------------------------------------------
-- * The EncodeTCM class

-- | The JSON version of`PrettyTCM`, for encoding JSON value in TCM
class EncodeTCM a where
  encodeTCM :: a -> TCM Value
  default encodeTCM :: ToJSON a => a -> TCM Value
  encodeTCM = return . toJSON

instance ToJSON Doc where
  toJSON = toJSON . render

renderDoc :: PrettyTCM a => a -> TCM String
renderDoc = fmap render . prettyTCM

obj :: [TCM Pair] -> TCM Value
obj pairs = object <$> sequence pairs

(@=) :: (ToJSON a) => Text -> a -> TCM Pair
(@=) key value = return (key .= toJSON value)

(#=) :: (ToJSON a) => Text -> TCM a -> TCM Pair
(#=) key boxed = do
  value <- boxed
  return (key .= toJSON value)
