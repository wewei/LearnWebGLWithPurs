module Reactive2.Behavior where

import Data.Tuple (Tuple, fst, snd)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Prelude (class Functor, class Apply, class Applicative, class Bind, class Monad, Unit, const, pure, bind, map, unit, discard, ($), (<<<), (<$>), (>>=))

newtype Behavior a = Behavior (Effect (Tuple a (Future a)))

observe :: forall a. Behavior a -> Effect (Tuple a (Future a))
observe (Behavior x) = x

peek :: forall a. Behavior a -> Effect a
peek beh = fst <$> observe beh

future :: forall a. Behavior a -> Effect (Future a)
future beh = snd <$> observe beh

newtype Future a = Future ((Behavior a -> Effect Unit) -> Effect Unit)
wait :: forall a. Future a -> (Behavior a -> Effect Unit) -> Effect Unit
wait (Future x) = x 

never :: forall a. Future a
never = Future <<< const <<< pure $ unit

joinFuture :: forall a. Future (Behavior a) -> Future a
joinFuture futBeh = Future
  $ \waitA -> wait futBeh
  $ \behA  -> peek behA >>= waitA

foreign import once :: forall a. (a -> Effect Unit) -> Effect (a -> Effect Unit)

either :: forall a. Future a -> Future a -> Future a
either futX futY = Future
  $ \waitZ -> do
    onceZ <- once waitZ
    wait futX onceZ
    wait futY onceZ

instance Functor Future where
  map :: forall a b. (a -> b) -> Future a -> Future b
  map f futA = Future
             $ \waitB -> wait futA
             $ \behA  -> waitB (map f behA)

instance Functor Behavior where
  map :: forall a b. (a -> b) -> Behavior a -> Behavior b
  map f behA = Behavior do
    (a /\ futA) <- observe behA
    pure (f a /\ map f futA)

instance Apply Behavior where
  apply :: forall a b. (Behavior (a -> b)) -> Behavior a -> Behavior b
  apply behF behA = Behavior do
    (f /\ futF) <- observe behF
    (a /\ futA) <- observe behA
    pure (f a /\ either (map (_ $ a) futF) (map f futA))

instance Applicative Behavior where
  pure :: forall a. a -> Behavior a
  pure a = Behavior (pure (a /\ never))

instance Bind Behavior where
  bind :: forall a b. (Behavior a) -> (a -> Behavior b) -> Behavior b
  bind behA f = Behavior do
    (a /\ futA) <- observe behA
    (b /\ futB) <- observe (f a)
    pure (b /\ either futB (joinFuture $ map f futA))

instance Monad Behavior