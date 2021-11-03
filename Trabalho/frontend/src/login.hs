{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

module Frontend where

import Control.Monad
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import Language.Javascript.JSaddle (eval, liftJSM)

import Obelisk.Frontend
import Obelisk.Configs
import Obelisk.Route
import Obelisk.Generated.Static


import Reflex.Dom.Core

import Common.Api
import Common.Route


-- This runs in a monad that can be run on the client or the server.
-- To run code in a pure client or pure server context, use one of the
-- `prerender` functions.
frontend :: Frontend (R FrontendRoute)
frontend = Frontend{
_frontend_head = do
      el "title" $ text "Mesa Livre"
      elAttr "link" ("href" =: static @"main.css" <> "type" =: "text/css" <> "rel" =: "stylesheet") blank
, _frontend_body = do
    prerender_ blank $ liftJSM $ void $ eval ("console.log('Hello, World!')" :: T.Text)
    --elClass "p" "teste" $ text "Testando CSS!"   divClass "" $ do
    -- el "p" $ text $ T.pack commonStuff

    --Header
    divClass "top-bar" $ do
        elClass "div" "Logo" $ do
            el "p" $ text "Mesa Livre"

        elClass "ul" "" $ do
            elClass "li" "p" $ text "Entrar"
            elClass "li" "p" $ text "Cadastrar"



    --Corpo
    divClass "borda-home-pesquisa imagem-index" $ do
        divClass "container-home" $ do
            elClass "input"  "tamanho" $ text "Pesquisar"
            elClass "button" ""$ text "Pesquisar"



    --Footer
    divClass "borda footer" $ do
        elClass "div" "footer-info" $ do
            el "ul" $ do
                elClass "h4" "empresa-footer" $ text "Mesa Livre"
                elClass "li" "footer-link" (text "Sobre")
                elClass "li" "footer-link" (text "Contato")
                elClass "li" "footer-link" (text "Suporte")
{--
        elClass "div" "footer-info" $ do
            el "ul" $ do
                elClass "h4" "empresa-footer" $ text "Mesa Livre"
                elClass "li" "imagem-footer-facebook" (text "")
                elClass "li" "imagem-footer-twitter"  (text "")
--}

    return ()
  }
