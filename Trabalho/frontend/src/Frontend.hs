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


data Pagina = Index | Index2 | Entrar | EscolherCad | Esqueci | CadCliente

clickLi :: DomBuilder t m => Pagina -> T.Text -> m (Event t Pagina)
clickLi p t = do
    (ev,_) <- el' "li" (elAttr "a" ("href" =: "#") (text t))
    return $ (const p) <$> (domEvent Click ev)

menuLi :: (DomBuilder t m, MonadHold t m) => m (Dynamic t Pagina)
menuLi = do
    evs <- el "ul" $ do
        p1 <- clickLi Entrar "Entrar"
        p2 <- clickLi EscolherCad "Cadastrar"
        p3 <- clickLi Index "Home"
        return (leftmost [p1,p2,p3])
    holdDyn Index evs

currPag :: (DomBuilder t m, MonadHold t m, PostBuild t m) => Pagina -> m ()
currPag p =
    case p of
        Index -> home
        Entrar -> login
        EscolherCad -> escolherCad
        Esqueci -> esqueci
        CadCliente -> cadCliente





--FOOTER E HEADER
--{--
header ::  DomBuilder t m => m()
header = do
        elClass "nav" "navbar navbar-default" $ do
        divClass "container-fluid" $ do
           divClass "container-header" $ do
                elClass "div" "navbar-header" $ do
                    elAttr "button" (
                                 --   "type" =: "button" <>
                                     "class" =: "navbar-toggle collapsed" <>
                                     "data-toggle" =: "collapse" <>
                                     "data-target" =: "#bs-example-navbar-collapse-1" <>
                                     "aria-expand" =: "false") $ do
                         elClass "span" "icon-bar" $ blank
                         elClass "span" "icon-bar" $ blank
                         elClass "span" "icon-bar" $ blank
                    elClass "a" "navbar-brand" $ text "Mesa Livre"

 {--

               divClass "collapse navbar-collapse navbar-right" $ do
                    evs <-  el "ul" $ do
                        --elAttr "p" ("class" =: "btn-nav") $ do
                        li1 <- clickLi Entrar "Entrar"
                        --elAttr "p" ("class" =: "btn-nav") $ do
                        li2 <- clickLi Cadastrar "Cadastrar"
                        return (leftmost [li1,li2])
                    holdDyn Entrar evs
                --


                divClass "collapse navbar-collapse navbar-right" $ do
                    elAttr "p" ("class" =: "btn-nav"  <> "href" =: "src/Frontend.hs") $ do
                    elAttr "p" ("class" =: "btn-nav"  <> "href" =: "cadastro-escolher.hs") $ text "Cadastrar"
                --}
--}
footer :: DomBuilder t m => m()
footer = do
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

-- PAGINAS DO SITE
mainPag :: (DomBuilder t m, MonadHold t m, PostBuild t m) => m ()
mainPag = do
    pag <- el "div" menuLi
    dyn_ $ currPag <$> pag

-- INDEX
home :: (DomBuilder t m, MonadHold t m, PostBuild t m) => m ()
home = do
       -- header
        divClass "imagem-index" $ do
        divClass "container-home" $ do
            elClass "input"  "form-control" $ text "Pesquisar"
            elClass "button" "btn-default"$ text "Pesquisar"
       -- footer

home2 :: (DomBuilder t m, MonadHold t m, PostBuild t m) => m ()
home2 = do
        --header
        divClass "borda-home-pesquisa imagem-index" $ do
        divClass "container-home" $ do
            elClass "input"  "form-control" $ text "Pesquisar"
            elClass "button" "btn-default"$ text "Pesquisar"
      --  footer
--LOGIN
login :: DomBuilder t m => m()
login = do
    --header
    divClass "imagem-login" $ do
        divClass "login-container" $ do
            elClass "div" "login-box" $ do
                elClass "ul" "" $ do
                    elClass "li" "elemento-login-box" $ do
                        elClass "h3"  "" $ text "Login"

                    elClass "li" "elemento-login-box" $ do
                        elClass "p" "" $ text "Digite o e-mail"
                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "input"  "" $ text "Digite o e-mail"



                    elClass "li" "elemento-login-box" $ do
                        elClass "p" "" $ text "Digite a Senha"
                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "input"  "" $ text "Digite a senha"


                    elClass "li" "elemento-login-box" $ do
                        elClass "button" "btn-default"$ text "Login"
    --footer

--ESQUECI SENHA
esqueci :: DomBuilder t m => m()
esqueci= do
       -- header
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
       -- footer

--ESCOLHER CADASTRO
escolherCad :: DomBuilder t m => m()
escolherCad = do
       -- header
        divClass "imagem-cadastro-escolher" $ do
        divClass "cadastro-container" $ do
            divClass "opcao-cadastro" $ do
                elClass "a" "titulo-opcao" $ text "Cadastrar como Cliente"

            divClass "opcao-cadastro" $ do
                elClass "a" "titulo-opcao" $ text "Cadastrar como Restaurante"


        --footer

--CADASTRAR-CLIENTE
cadCliente :: DomBuilder t m => m()
cadCliente = do
        --header
        divClass "imagem-login" $ do
        divClass "cadastro-container" $ do
            elClass "div" "cadastro-box" $ do
                elClass "ul" "" $ do
                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "h3"  "" $ text "Login"

                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "p" "" $ text "Digite o e-mail"
                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "input"  "" $ text "Digite o e-mail"

                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "p" "" $ text "Digite novamente o e-mail"
                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "input"  "" $ text "Digite o e-mail"

                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "p" "" $ text "Digite a Senha"
                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "input"  "" $ text "Digite a senha"

                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "p" "" $ text "Digite novamente a Senha"
                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "input"  "" $ text "Digite a senha"

                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "a"  "" $ text "Termos de uso"


                    elClass "li" "elemento-cadastro-box" $ do
                        elClass "button" "btn-default"$ text "Cadastrar"

        --footer


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

    elClass "nav" "navbar navbar-default" $ do
        divClass "container-fluid" $ do
           divClass "container-header" $ do
                elClass "div" "navbar-header" $ do
                    elAttr "button" (
                                 --   "type" =: "button" <>
                                     "class" =: "navbar-toggle collapsed" <>
                                     "data-toggle" =: "collapse" <>
                                     "data-target" =: "#bs-example-navbar-collapse-1" <>
                                     "aria-expand" =: "false") $ do
                         elClass "span" "icon-bar" $ blank
                         elClass "span" "icon-bar" $ blank
                         elClass "span" "icon-bar" $ blank
                    elClass "a" "navbar-brand" $ text "Mesa Livre"
        --divClass "collapse navbar-collapse navbar-right" $ do
        mainPag


    footer


    elAttr "scrpit" ("href" =: static @"js/bootstrap.min.js") blank
    elAttr "script" ("href" =: static @"js/jquery-3.6.0.min.js") blank
    return ()
  }
