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
      elAttr "link" ("href" =: static @"css/bootstrap.min.css" <> "type" =: "text/css" <> "rel" =: "stylesheet") blank
--      elAttr "link" ("href" =: static @"css/style.css" <> "type" =: "text/css" <> "rel" =: "stylesheet") blank
, _frontend_body = do
    prerender_ blank $ liftJSM $ void $ eval ("console.log('Hello, World!')" :: T.Text)
    --elClass "p" "teste" $ text "Testando CSS!"   divClass "" $ do
    -- el "p" $ text $ T.pack commonStuff

-----------------------------HEADER-----------------------------

    elClass "nav" "navbar-default" $ do
        divClass "container-fluid" $ do
            elClass "div" "Logo nav navbar navbar-left" $ do
                elClass "p" "navbar-brand" $ text "Mesa Livre"

{-- VER COMO ARRUMAR
        divClass "collapse navbar-collapse" $ do
            elClass "ul" "nav navbar-nav navbar-right" $ do
                elClass "li" "p" $ text "Entrar"
                elClass "li" "p" $ text "Cadastrar"
--}

-----------------------------CORPO-----------------------------
    divClass "imagem-esqueci" $ do
        divClass "esqueci-container" $ do
            elClass "div" "esqueci-box" $ do
                elClass "ul" "" $ do
                    elClass "li" "elemento-box" $ do
                        elClass "h3"  "" $ text "Esqueci a Senha"

                    elClass "li" "elemento-box" $ do
                        elClass "p" "" $ text "Digite o e-mail da conta para poder recuperar a senha."

                    elClass "li" "elemento-box" $ do
                        elClass "input"  "" $ text "Digite o e-mail"

                    elClass "li" "elemento-box" $ do
                        elClass "button" "btn-default"$ text "Enviar"




-----------------------------FOOTER-----------------------------
    divClass "borda footer" $ do
        elClass "ul" "footer-info-geral" $ do
            elClass "ul" "footer-mesa-livre" $ do
                elClass "h4" "empresa-footer" $ text "Mesa Livre"
                elClass "li" "footer-link" (text "Sobre")
                elClass "li" "footer-link" (text "Contato")
                elClass "li" "footer-link" (text "Suporte")

            elClass "ul" "footer-redes" $ do
                elClass "h4" "empresa-footer" $ text "Redes Sociais"
                elClass "li" "footer-link" (text "Facebook") -- como por imagem aqui
                elClass "li" "footer-link" (text "Twitter") -- como por imagem aqui

    return ()
  }

