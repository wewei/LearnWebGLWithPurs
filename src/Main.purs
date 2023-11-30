module Main where

import Prelude

import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Console (log)
import Graphics.Canvas (CanvasElement, fillPath, getCanvasElementById, getContext2D, rect, setFillStyle)
import Web.DOM.Document (toNonElementParentNode)
import Web.DOM.Element (Element, clientHeight, clientWidth, setAttribute)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.Window (document)

render :: CanvasElement -> Effect Unit
render canvas = do
    ctx <- getContext2D canvas
    setFillStyle ctx "#f0f"
    fillPath ctx $ rect ctx
        { height : 100.0
        , width  : 100.0
        , x      : 50.0
        , y      : 50.0 }

prepare :: Element -> Effect Unit
prepare canvas = do
    width <- clientWidth canvas
    height <- clientHeight canvas
    setAttribute "width" (show width) canvas
    setAttribute "height" (show height) canvas

main :: Effect Unit
main = do
    window
        >>= document
        >>= pure <<< toDocument
        >>= pure <<< toNonElementParentNode
        >>= getElementById "my-canvas"
        >>= maybe (pure unit) prepare
    getCanvasElementById "my-canvas" >>= maybe (pure unit) render
    log "Rendered!"
