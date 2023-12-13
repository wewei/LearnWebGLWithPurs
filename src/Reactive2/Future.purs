module Reactive2.Future where

import Prelude

import Data.Either (Either(..), either) as E
import Data.List (List(..), foldM, null)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Ref (modify_, new, read)

newtype Future a = Future (Effect ((a -> Effect Unit) -> Effect Unit))

observe :: forall a. Future a -> Effect ((a -> Effect Unit) -> Effect Unit)
observe (Future effObs) = effObs

buffered :: forall a. Future a -> Future a
buffered fut = Future do
  refHdls <- new (Nil :: List (a -> Effect Unit))
  pure $ \hdl -> do
    hdls <- read refHdls
    modify_ (Cons hdl) refHdls
    when (null hdls) $ do
      obs <- observe fut
      obs \val -> do
        hdls' <- read refHdls
        modify_ (const Nil) refHdls
        foldM (const (\h -> h val)) unit hdls'

never :: forall a. Future a
never = Future <<< pure <<< const <<< pure $ unit

once :: forall a. (a -> Effect Unit) -> Effect (a -> (Effect Unit))
once hdl = do
  refInit <- new true
  pure $ \val -> do
    init <- read refInit
    when init $ do
      modify_ (const false) refInit
      hdl val

either :: forall a b. Future a -> Future b -> Future (E.Either a b)
either futA futB = Future do
  obsA <- observe futA
  obsB <- observe futB
  pure \hdl -> do
    hdl1 <- once hdl
    obsA (hdl1 <<< E.Left)
    obsB (hdl1 <<< E.Right)

either1 :: forall a. Future a -> Future a -> Future a
either1 futA futB = E.either identity identity <$> either futA futB

both :: forall a b. Future a -> Future b -> Future (Tuple a b)
both futA futB = Future do
  refA <- new Nothing
  refB <- new Nothing
  obsA <- observe futA
  obsB <- observe futB
  pure \hdl -> do
    let tryResolve = do mA <- read refA
                        mB <- read refB
                        case (mA /\ mB) of
                          (Just a /\ Just b) -> hdl (a /\ b)
                          _                  -> pure unit
    obsA $ \a -> do
      modify_ (const (Just a)) refA
      tryResolve
    obsB $ \b -> do
      modify_ (const (Just b)) refB
      tryResolve

instance Functor Future where
  map :: forall a b. (a -> b) -> Future a -> Future b
  map f fut = buffered $ Future do
    obs <- observe fut
    pure $ \hdl -> obs (hdl <<< f)

instance Apply Future where
  apply :: forall a b. Future (a -> b) -> Future a -> Future b
  apply futF futA = Future do
    obsBoth <- observe $ both futF futA
    pure $ \hdl -> obsBoth $ \(f /\ a) -> hdl (f a)

