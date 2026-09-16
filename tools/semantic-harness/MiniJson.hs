module MiniJson
  ( Json (..)
  , asString
  , decodeJson
  , encodeJson
  , lookupKey
  , object
  , stringsDeep
  ) where

import Data.Char (chr, isDigit, isHexDigit, ord)
import Data.List (intercalate)
import qualified Data.Map.Strict as Map
import Data.Map.Strict (Map)
import Numeric (readHex, showHex)
import Text.ParserCombinators.ReadP

data Json
  = JObject (Map String Json)
  | JArray [Json]
  | JString String
  | JNumber String
  | JBool Bool
  | JNull
  deriving (Eq, Show)

decodeJson :: String -> Either String Json
decodeJson source =
  case [value | (value, "") <- readP_to_S (skipSpaces *> jsonValue <* skipSpaces <* eof) source] of
    [] -> Left "invalid JSON"
    values -> Right (last values)

encodeJson :: Json -> String
encodeJson value =
  case value of
    JObject fields ->
      "{" ++ intercalate "," [encodeString key ++ ":" ++ encodeJson item | (key, item) <- Map.toList fields] ++ "}"
    JArray items -> "[" ++ intercalate "," (map encodeJson items) ++ "]"
    JString item -> encodeString item
    JNumber item -> item
    JBool True -> "true"
    JBool False -> "false"
    JNull -> "null"

object :: [(String, Json)] -> Json
object = JObject . Map.fromList

lookupKey :: String -> Json -> Maybe Json
lookupKey key (JObject fields) = Map.lookup key fields
lookupKey _ _ = Nothing

asString :: Json -> Maybe String
asString (JString value) = Just value
asString _ = Nothing

stringsDeep :: Json -> [String]
stringsDeep value =
  case value of
    JObject fields -> concatMap stringsDeep (Map.elems fields)
    JArray items -> concatMap stringsDeep items
    JString item -> [item]
    JNumber item -> [item]
    JBool item -> [if item then "true" else "false"]
    JNull -> []

jsonValue :: ReadP Json
jsonValue =
  (JObject . Map.fromList <$> jsonObject)
    <++ (JArray <$> jsonArray)
    <++ (JString <$> jsonString)
    <++ (JNumber <$> jsonNumber)
    <++ (string "true" >> pure (JBool True))
    <++ (string "false" >> pure (JBool False))
    <++ (string "null" >> pure JNull)

jsonObject :: ReadP [(String, Json)]
jsonObject =
  between
    (char '{' *> skipSpaces)
    (skipSpaces *> char '}')
    (sepBy member (skipSpaces *> char ',' *> skipSpaces))
  where
    member = do
      key <- jsonString
      skipSpaces
      _ <- char ':'
      skipSpaces
      value <- jsonValue
      pure (key, value)

jsonArray :: ReadP [Json]
jsonArray =
  between
    (char '[' *> skipSpaces)
    (skipSpaces *> char ']')
    (sepBy jsonValue (skipSpaces *> char ',' *> skipSpaces))

jsonString :: ReadP String
jsonString = between (char '"') (char '"') (many stringCharacter)

stringCharacter :: ReadP Char
stringCharacter =
  satisfy (\character -> character >= ' ' && character /= '"' && character /= '\\')
    <++ escapedCharacter

escapedCharacter :: ReadP Char
escapedCharacter = do
  _ <- char '\\'
  choice
    [ char '"' >> pure '"'
    , char '\\' >> pure '\\'
    , char '/' >> pure '/'
    , char 'b' >> pure '\b'
    , char 'f' >> pure '\f'
    , char 'n' >> pure '\n'
    , char 'r' >> pure '\r'
    , char 't' >> pure '\t'
    , char 'u' >> unicodeCharacter
    ]

unicodeCharacter :: ReadP Char
unicodeCharacter = do
  high <- fourHexDigits
  if high >= 0xD800 && high <= 0xDBFF
    then do
      _ <- string "\\u"
      low <- fourHexDigits
      if low >= 0xDC00 && low <= 0xDFFF
        then pure (chr (0x10000 + (high - 0xD800) * 0x400 + low - 0xDC00))
        else pfail
    else
      if high >= 0xDC00 && high <= 0xDFFF
        then pfail
        else pure (chr high)

fourHexDigits :: ReadP Int
fourHexDigits = do
  digits <- count 4 (satisfy isHexDigit)
  case readHex digits of
    [(value, "")] -> pure value
    _ -> pfail

jsonNumber :: ReadP String
jsonNumber = do
  sign <- option "" (string "-")
  whole <- string "0" <++ ((:) <$> satisfy (\c -> c >= '1' && c <= '9') <*> munch isDigit)
  fraction <- option "" ((:) <$> char '.' <*> munch1 isDigit)
  exponentPart <- option "" exponentPartParser
  pure (sign ++ whole ++ fraction ++ exponentPart)
  where
    exponentPartParser = do
      marker <- satisfy (\c -> c == 'e' || c == 'E')
      exponentSign <- option "" ((: []) <$> satisfy (\c -> c == '+' || c == '-'))
      digits <- munch1 isDigit
      pure (marker : exponentSign ++ digits)

encodeString :: String -> String
encodeString value = "\"" ++ concatMap encodeCharacter value ++ "\""

encodeCharacter :: Char -> String
encodeCharacter character =
  case character of
    '"' -> "\\\""
    '\\' -> "\\\\"
    '\b' -> "\\b"
    '\f' -> "\\f"
    '\n' -> "\\n"
    '\r' -> "\\r"
    '\t' -> "\\t"
    _
      | ord character < 0x20 -> "\\u" ++ padFour (showHex (ord character) "")
      | otherwise -> [character]

padFour :: String -> String
padFour digits = replicate (4 - length digits) '0' ++ digits
