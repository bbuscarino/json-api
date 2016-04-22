{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module TestHelpers where

import qualified Data.Aeson as AE
import qualified Data.Aeson.Encode.Pretty as AE
import qualified Data.ByteString.Lazy.Char8 as BS
import           Data.Maybe (fromJust)
import qualified Data.Map as Map
import           Data.Text (Text, pack)
import           GHC.Generics
import           Network.JsonApi
import           Network.Meta
import           Network.URL (URL, importURL)

prettyEncode :: AE.ToJSON a => a -> BS.ByteString
prettyEncode = AE.encodePretty' prettyConfig

prettyConfig :: AE.Config
prettyConfig = AE.Config { AE.confIndent = 2, AE.confCompare = mempty }

data TestResourceObject =
  TestResourceObject { myId :: Int
                     , myName :: Text
                     , myAge :: Int
                     , myFavoriteFood :: Text
                     } deriving (Show, Generic)

data TestMetaObject =
  TestMetaObject { totalPages :: Int
                 , isSuperFun :: Bool
                 } deriving (Show, Generic)

instance AE.ToJSON TestResourceObject
instance AE.FromJSON TestResourceObject

instance AE.ToJSON TestMetaObject
instance AE.FromJSON TestMetaObject

instance ToResourceObject TestResourceObject where
  toResource a =
    ResourceObject
      (ResourceId . pack . show . myId $ a)
      (ResourceType "TestResourceObject")
      a

testObject :: TestResourceObject
testObject = TestResourceObject 1 "Fred Armisen" 49 "Pizza"

testMetaObj :: Meta TestMetaObject
testMetaObj =
  Meta . Map.fromList $ [ ("importantData", TestMetaObject 3 True) ]

emptyMeta :: Maybe (Meta TestMetaObject)
emptyMeta = Nothing

linksObj :: Links
linksObj = toLinks [ ("self", toURL "/things/1")
                   , ("related", toURL "http://some.domain.com/other/things/1")
                   ]

toURL :: String -> URL
toURL = fromJust . importURL

emptyLinks :: Maybe Links
emptyLinks = Nothing
