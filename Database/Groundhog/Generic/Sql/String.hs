{-# LANGUAGE Rank2Types #-}
module Database.Groundhog.Generic.Sql.String
    ( module Database.Groundhog.Generic.Sql
    , StringS (..)
    ) where

import Database.Groundhog.Core
import Database.Groundhog.Generic.Sql
import Data.Monoid
import Data.String

newtype StringS = StringS { fromStringS :: ShowS }

instance Monoid StringS where
  mempty = StringS id
  (StringS s1) `mappend` (StringS s2) = StringS (s1 . s2)

instance IsString StringS where
  fromString s = StringS (s++)

instance StringLike StringS where
  fromChar c = StringS (c:)

{-# SPECIALIZE (<>) :: RenderS StringS -> RenderS StringS -> RenderS StringS #-}

{-# SPECIALIZE renderArith :: PersistEntity v => (String -> String) -> Arith v c a -> RenderS StringS #-}

{-# SPECIALIZE renderCond :: PersistEntity v
  => (String -> String)
  -> String -- name of id in constructor table
  -> (forall a.PersistField a => (String -> String) -> Expr v c a -> Expr v c a -> RenderS StringS)
  -> (forall a.PersistField a => (String -> String) -> Expr v c a -> Expr v c a -> RenderS StringS)
  -> Cond v c -> RenderS StringS #-}

{-# SPECIALIZE defRenderEquals :: PersistField a => (String -> String) -> Expr v c a -> Expr v c a -> RenderS StringS #-}
{-# SPECIALIZE defRenderNotEquals :: PersistField a => (String -> String) -> Expr v c a -> Expr v c a -> RenderS StringS #-}

{-# SPECIALIZE renderExpr :: (String -> String) -> Expr v c a -> RenderS StringS #-}

{-# SPECIALIZE renderOrders :: PersistEntity v => (String -> String) -> [Order v c] -> StringS #-}

{-# SPECIALIZE renderUpdates :: PersistEntity v => (String -> String) -> [Update v c] -> RenderS StringS #-}

{-# SPECIALIZE renderFields :: (StringS -> StringS) -> [(String, NamedType)] -> StringS #-}