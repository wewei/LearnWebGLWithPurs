module Reactive2.Behavior
  ( Behavior(..)
  , current
  , future
  )
  where

import Prelude

import Effect (Effect)
import Effect.Class (liftEffect)
import Reactive2.Future (Future, either1, never)

-- newtype Behavior a = Behavior (Effect (Tuple a (Future a)))
data Behavior a = Behavior (Effect a) (Future (Behavior a))

-- observe :: forall a. Behavior a -> Effect (Tuple a (Future a))
-- observe (Behavior x) = x

current :: forall a. Behavior a -> Effect a
current (Behavior cur _) = cur

future :: forall a. Behavior a -> Future (Behavior a)
future (Behavior _ fut) = fut

-- joinFuture :: forall a. Future (Behavior a) -> Future a
-- joinFuture futBeh = Future
--   $ \hdlA -> wait futBeh
--   $ \behB -> current behB >>= hdlA

instance Functor Behavior where
  map :: forall a b. (a -> b) -> Behavior a -> Behavior b
  map f behA = Behavior (f <$> current behA) (map (map f) <<< future $ behA)

instance Apply Behavior where
  apply :: forall a b. (Behavior (a -> b)) -> Behavior a -> Behavior b
  apply (Behavior effF futF) (Behavior effA futA) =
    Behavior (effF <*> effA) $ join <<< liftEffect $ do
      f <- effF
      a <- effA
      pure $ either1 (map (map (_ $ a)) futF) (map (map f) futA)

instance Applicative Behavior where
  pure :: forall a. a -> Behavior a
  pure a = Behavior (pure a) never

instance Bind Behavior where
  bind :: forall a b. (Behavior a) -> (a -> Behavior b) -> Behavior b
  bind behA f = let
    effBehB :: Effect (Behavior b)
    effBehB = f <$> current behA
    in Behavior
      (join $ current <$> effBehB)
      (either1 (bind <$> (future behA) <*> pure f)
               (join $ liftEffect (future <$> effBehB)))

instance Monad Behavior

-- counter :: Int -> Effect (Behavior Int)
-- counter ms = do
--   init <- now

--   let ctr = Behavior do
--             curr <- now
--             let (Milliseconds m) = diff init curr
--             let dlt = floor m
--             let cnt = dlt `div` ms
--             pure (cnt /\ fut)
--       fut = Future $ \hdl -> do
--             curr <- now
--             let (Milliseconds m) = diff init curr
--             let dlt = floor m
--             let cnt = dlt `div` ms
--             let gap = (cnt + 1) * ms - dlt
--             void $ setTimeout gap (hdl ctr)

--   pure ctr
    

  